import 'package:audioplayers/audioplayers.dart';
import 'package:exci_flutter/models/folder_model.dart';
import 'package:flutter/material.dart';

// class WordListScreen extends StatelessWidget{
//   final FolderModel folder;

//   const WordListScreen({required this.folder});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(folder.name),
//       ),
//       body: ListView.builder(
//         itemCount: folder.listWord.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(folder.listWord[index].word),
//           );
//         },
//       ),
//     );
//   }

// }

class WordListScreen extends StatefulWidget {
  final FolderModel folder;

  WordListScreen({required this.folder});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  int _currentIndex = 0;
  String _userInput = '';
  bool _showMeaning = true;
  bool _isCorrect = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _nextWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.folder.listWord.length;
      _showMeaning = true;
      _userInput = '';
      _isCorrect = false;
    });
  }

  void _skipWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.folder.listWord.length;
      _showMeaning = true;
      _userInput = '';
      _isCorrect = false;
    });
  }

  void _checkAnswer(String answer) {
    final currentWord = widget.folder.listWord[_currentIndex];
    setState(() {
      _isCorrect = answer.trim().toLowerCase() == currentWord.word.toLowerCase();
    });
  }

  void _playAudio() {
    final currentWord = widget.folder.listWord[_currentIndex];
    _audioPlayer.play(UrlSource(currentWord.audio));
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
            if (_showMeaning) ...[
              // Hiển thị thông tin từ
              Text(
                'Word: ${currentWord.word}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('IPA: ${currentWord.ipa}'),
              Text('Part of Speech: ${currentWord.pos}'),
              Text('Meaning: ${currentWord.meaning}'),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => _userInput = value,
                decoration: InputDecoration(
                  labelText: 'Enter the meaning',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _checkAnswer(_userInput);
                  if (_isCorrect) {
                    setState(() {
                      _showMeaning = false;
                    });
                  }
                },
                child: Text('Check'),
              ),
            ] else if ( !_showMeaning && !_isCorrect) ...[
              // Hiển thị nút phát âm
              ElevatedButton(
                onPressed: _playAudio,
                child: Text('Play Pronunciation'),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => _userInput = value,
                decoration: InputDecoration(
                  labelText: 'Enter the word',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _checkAnswer(_userInput);
                  if (_isCorrect) {
                    _nextWord();
                  }
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
                  onPressed: _isCorrect || !_showMeaning ? _nextWord : null,
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