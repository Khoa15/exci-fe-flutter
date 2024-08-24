import 'package:exci_flutter/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class WordListScreen extends StatefulWidget {
  final FolderModel folder;

  WordListScreen({required this.folder});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  int _currentIndex = 0;
  int _currentPart = 1;
  int _wrongAttempts = 0;
  bool _isCorrect = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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

    if (_currentIndex >= widget.folder.listWord.length) {
      _showCongratulationsScreen();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _skipWord() {
    _nextPart();
  }

  void _checkAnswer(String answer) {
    final currentWord = widget.folder.listWord[_currentIndex];
    setState(() {
      _isCorrect = answer.trim().toLowerCase() == currentWord.word.toLowerCase();
      if (!_isCorrect) {
        _wrongAttempts++;
      }
    });

    if (_isCorrect) {
      _nextPart();
    } else if (_wrongAttempts >= 3) {
      _showHint();
    }
  }

  void _playAudio() async {
    final currentWord = widget.folder.listWord[_currentIndex];
    if (currentWord.audio != null) {
      await _audioPlayer.play(UrlSource(currentWord.audio));
    }
  }

  void _showHint() {
    showDialog(
      context: context,
      builder: (context) {
        final currentWord = widget.folder.listWord[_currentIndex];
        return AlertDialog(
          title: Text('Hint'),
          content: Text('The correct word is: ${currentWord.word}'),
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
    final currentWord = widget.folder.listWord[_currentIndex];
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
                'Word: ${currentWord.word}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('IPA: ${currentWord.ipa}'),
              Text('Part of Speech: ${currentWord.pos}'),
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
              Text('Meaning: ${currentWord.meaning}'),
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
                  onPressed: _isCorrect || _wrongAttempts >= 3 ? _nextPart : null,
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
