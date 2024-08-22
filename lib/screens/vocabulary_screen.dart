import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allWords = [
    {
      'word': 'apple',
      'ipa': 'ˈæpəl',
      'partOfSpeech': 'noun',
      'meaning': 'A round fruit with red or green skin and a whitish interior.',
      'audioUrl': 'https://example.com/apple.mp3'
    },
    {
      'word': 'banana',
      'ipa': 'bəˈnænə',
      'partOfSpeech': 'noun',
      'meaning': 'A long, curved fruit with a yellow skin and soft, sweet, white flesh inside.',
      'audioUrl': 'https://example.com/banana.mp3'
    },
    // Thêm nhiều từ hơn nếu cần
  ];
  List<Map<String, String>> _filteredWords = [];
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/vocabulary');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  void _filterWords() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        _filteredWords = _allWords;
      } else {
        _filteredWords = _allWords.where((word) {
          return word['word']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showReportDialog(String word) {
    final TextEditingController _reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report Issue for "$word"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reportController,
                decoration: InputDecoration(
                  labelText: 'Enter description',
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn Submit
                print('Report submitted: ${_reportController.text}');
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search for a word',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0)
                        )
                      ),
                    ),
                    onSubmitted: (value) => _filterWords(), // Khi nhấn Enter
                  ),
                ),
                // SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    color: Colors.blue,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _filterWords, // Khi nhấn nút tìm kiếm
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Danh sách các từ tìm thấy
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _filteredWords.length,
              itemBuilder: (context, index) {
                final wordData = _filteredWords[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          wordData['word']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          // Xử lý phát âm từ
                          print('Playing audio for ${wordData['word']}');
                        },
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IPA: ${wordData['ipa']}'),
                      Text('Part of Speech: ${wordData['partOfSpeech']}'),
                      Text('Meaning: ${wordData['meaning']}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý lưu từ
                              print('Saving ${wordData['word']}');
                            },
                            child: Text('Save'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showReportDialog(wordData['word']!);
                            },
                            child: Text('Report'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
