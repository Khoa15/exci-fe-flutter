import 'dart:convert';

import 'package:exci_flutter/models/collection.dart';
import 'package:exci_flutter/models/user.dart';
import 'package:exci_flutter/models/word_stat.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/services/word_service.dart';
// import 'package:exci_flutter/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class WordListScreen extends StatefulWidget {
  final int collectionId;
  // final int userId;
  WordListScreen({required this.collectionId});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final startGame = DateTime.now();
  late ListWordStat _wordStat;
  Collection? _collection;
  User? _user;
  int _currentIndex = 0;
  int _currentPart = 1;
  int _wrongAttempts = 0;
  int _nWrongAnswers = 0;
  bool _isCorrect = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _fetchDataCollection();
    _loadUser();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  Future<void> _loadUser() async {
    User? user = await getUser();
    setState(() {
      _user = user;
    });
  }

  
  Future<void> _saveSectionLearning() async {
    try{
      final url = Uri.parse('https://localhost:7235/api/SectionLearnings/');
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "uid": _user!.id,
            "n_total_words": _collection!.listWords!.length,
            "n_f_answers": _nWrongAnswers,
            "spanLearn": DateTime.now().difference(startGame).inSeconds
          }),
        );

      if (response.statusCode != 200) {
        throw Exception('Failed to save the section learning');
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> _saveWordStat() async {
    try{
      _wordStat.Save();
    }catch(error){
      print(error);
    }
  }

  Future<void> _fetchDataCollection() async {
    try{
        var url = Uri.parse('https://localhost:7235/api/Collections/${widget.collectionId}');
      if(widget.collectionId == -1){
        await _loadUser();
        url = Uri.parse('https://localhost:7235/api/USER_VOCAB/ready/${_user!.id}');
      }
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _collection = Collection.fromJson(jsonData);
          _wordStat = ListWordStat(_collection!.listWords!, _user!.id);
        });
        
      } else {
        throw Exception('Failed to load collections');
      }
    }catch(error){
      print(error);
    }
  }

  void _nextPart() {
    setState(() {
      _currentPart++;
      _textController.clear();
      _isCorrect = false;
      _wrongAttempts = 0;
    });

    if (_currentPart > 3) {
      _nextWord();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _nextWord() {
    setState(() {
      _currentIndex++;
      _currentPart = 1;
      _textController.clear();
      _isCorrect = false;
      _wrongAttempts = 0;
    });

    if (_currentIndex >= _collection!.listWords!.length) {
      _showCongratulationsScreen();
      _saveSectionLearning();
      _saveWordStat();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _skipWord() {
    _nextPart();
  }

  void _checkAnswer(String answer) {
    final currentWord = _collection!.listWords![_currentIndex];
    WordStat? stat = _wordStat.Search(currentWord.id);
    // currentWord.wordStat ??= WordStat(
    //     wordId: currentWord.id,
    //     userId: _user!.id,
    //     nSteak: 0,
    //     nMaxSteak: 0,
    //     memoryStat: 0,
    //     nListening: 0,
    //     nFListening: 0, nReading: 0, nFReading: 0, nWriting: 0, nFWriting: 0, nSpeaking: 0, nFSpeaking: 0
    //     );
    switch(_currentPart){      
      case 2:
        stat!.nListening+=1;
        if(!_isCorrect){
          stat.nFListening++;
          // stat.nSteak = 0;
        }
      case 3:
        stat!.nReading+=1;
        if(!_isCorrect){
          stat.nFReading++;
          // stat.nSteak = 0;
        }
    }
    
    setState(() {
      _isCorrect =
          answer.trim().toLowerCase() == currentWord.sign?.toLowerCase();
      // currentWord.wordStat?.nSteak++;
      if (!_isCorrect) {
        _wrongAttempts++;
        _nWrongAnswers++;
      }
    });

    if (_isCorrect) {
      _nextPart();
    } else if (_wrongAttempts >= 3) {
      _showHint();
    }
  }

  void _playAudio() async {
    try{
      final currentWord = _collection!.listWords![_currentIndex];
      if (currentWord.sound != null) {
        await _audioPlayer.play(UrlSource(currentWord.sound ?? ''));
      }
    }catch(error){
      print(error);
    }
  }

  void _showHint() {
    showDialog(
      context: context,
      builder: (context) {
        final currentWord = _collection!.listWords![_currentIndex];
        return AlertDialog(
          title: Text('Hint'),
          content: Text('The correct word is: ${currentWord.sign}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextPart();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCongratulationsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CongratulationsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final currentWord = _collection!.listWords?[_currentIndex];
    final currentWord = (_collection != null && _collection!.listWords != null && _collection!.listWords!.isNotEmpty && _collection!.listWords!.length > _currentIndex)
    ? _collection?.listWords![_currentIndex]
    : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentPart == 1) ...[
              // Part 1: Hiển thị thông tin từ
              Text(
                'Word: ${currentWord?.sign}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('IPA: ${currentWord?.ipa}'),
              Text('Part of Speech: ${currentWord?.pos}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextPart,
                child: Text('Next'),
              ),
            ] else if (_currentPart == 2) ...[
              // Part 2: Nghe phát âm và nhập từ
              ElevatedButton(
                onPressed: _playAudio,
                child: Text('Play Pronunciation'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter the word',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _checkAnswer(_textController.text);
                },
                child: Text('Check'),
              ),
            ] else if (_currentPart == 3) ...[
              // Part 3: Hiển thị nghĩa và nhập lại từ
              Text('Meaning: ${currentWord?.meaning}'),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter the word again',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _checkAnswer(_textController.text);
                },
                child: Text('Check'),
              ),
            ],
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _skipWord,
                  child: Text('Skip'),
                ),
                ElevatedButton(
                  onPressed:
                      _isCorrect || _wrongAttempts >= 3 ? _nextPart : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CongratulationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations'),
      ),
      body: Center(
        child: Text(
          'You have completed all the words!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
