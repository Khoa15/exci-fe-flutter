import 'dart:convert';

import 'package:exci_flutter/models/user.dart';
import 'package:exci_flutter/models/word.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/utils/constants.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  User? _user;
  String _selectedSearchOption = 'System';
  List<Word>? _allWords = [];
  List<Word> _filteredWords = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  Future<void> _loadUser() async {
    User? user = await getUser();
    setState(() {
      _user = user;
    });
  }
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

  void _executeSearch() {
    switch (_selectedSearchOption) {
      case 'System':
        _searchInSystem();
        break;
      case 'Storage':
        _searchInStorage();
        break;
      case 'Dictionary':
        _searchDictionary();
        break;
    }
  }

  void _searchInSystem() {
    _searchWords();
  }

  void _searchInStorage() {
    // Add the logic to search within the stored vocabulary
  }

  void _searchDictionary() {
    _searchDictionaryWords();
  }

  Word parseWordFromJson(Map<String, dynamic> json) {
    // Find the first non-null sound URL in phonetics
    String? soundUrl;
    if (json['phonetics'] != null) {
      for (var phonetic in json['phonetics']) {
        if (phonetic['audio'] != null && phonetic['audio'].isNotEmpty) {
          soundUrl = phonetic['audio'];
          break;
        }
      }
    }

    return Word(
      id: 0, // Set default or assign as necessary
      sign: json['word'] ?? '',
      pos: json['meanings'] != null && json['meanings'].isNotEmpty
          ? json['meanings'][0]['partOfSpeech']
          : '',
      ipa: json['phonetic'] ?? '',
      sound: soundUrl,
      meaning: json['meanings'] != null && json['meanings'].isNotEmpty
          ? json['meanings'][0]['definitions'][0]['definition']
          : '',
      example: json['meanings'] != null && json['meanings'].isNotEmpty
          ? json['meanings'][0]['definitions'][0]['example']
          : '',
      level: '', // Assign level if available or leave as empty
      collectionId: null, // Collection ID not included, set as null or default
    );
  }

  Future<void> _searchDictionaryWords() async {
    final query = _searchController.text;
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/' + query);
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // final result = jsonDecode(response.body);
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          var firstElement = jsonData[0];
          Word word = parseWordFromJson(firstElement);
          setState(() {
            _filteredWords.clear();
            _filteredWords.add(word);
          });
        }
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> _searchWords() async {
    final query = _searchController.text;
    final url = Uri.parse('${host}/words/' + query);
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // final result = jsonDecode(response.body);
        List<dynamic> jsonData = jsonDecode(response.body);

        List<Word> words = jsonData.map((json) => Word.fromJson(json)).toList();
        setState(() {
          _filteredWords = words;
        });
      } else {}
    } catch (error) {
      print(error);
    }
  }

  void _filterWords() {
    // final query = _searchController.text;
    // setState(() {
    //   if (query.isEmpty) {
    //     _filteredWords = _allWords;
    //   } else {
    //     _filteredWords = _allWords.where((word) {
    //       return word['word']!.toLowerCase().contains(query.toLowerCase());
    //     }).toList();
    //   }
    // });
  }

  Future<void> _saveWord(Word word) async{
    try{

      final response = await http.post(
        Uri.parse('${host}/api/Vocabs'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "uid": _user!.id,
          "vocab": word.sign,
          "pos": word.pos,
          "collection_id": 0,
          "ipa": word.ipa,
          "sound": word.sound,
          "meaning": word.meaning,
          "example": word.example,
          "level": ""
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add collection')),
        );
      }
    }catch(error){
      print(error);
    }
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
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _searchController,
          //           decoration: InputDecoration(
          //             labelText: 'Search for a word',
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(16.0),
          //                     bottomLeft: Radius.circular(16.0),
          //                     topRight: Radius.circular(0),
          //                     bottomRight: Radius.circular(0))),
          //           ),
          //           onSubmitted: (_) =>
          //               _searchDictionaryWords(), //_filterWords(), // Khi nhấn Enter
          //         ),
          //       ),
          //       // SizedBox(width: 8.0),
          //       Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(16.0),
          //             bottomRight: Radius.circular(16.0),
          //           ),
          //           color: Colors.blue,
          //         ),
          //         child: Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             onTap:
          //                 _searchWords, //_filterWords, // Khi nhấn nút tìm kiếm
          //             borderRadius: BorderRadius.only(
          //               topRight: Radius.circular(16.0),
          //               bottomRight: Radius.circular(16.0),
          //             ),
          //             child: Container(
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: 16.0, vertical: 12.0),
          //               child: Center(
          //                 child: Icon(
          //                   Icons.search,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSearchOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSearchOption = newValue!;
                    });
                  },
                  items: <String>['System', 'Dictionary'] // No "Storage"
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: Container(),
                ),
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
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _executeSearch(),
                  ),
                ),
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
                      onTap: _executeSearch,
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
                          wordData.sign!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          // Xử lý phát âm từ
                          print('Playing audio for ${wordData.sign}');
                        },
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IPA: ${wordData.ipa}'),
                      Text('Part of Speech: ${wordData.pos}'),
                      Text('Meaning: ${wordData.meaning}'),
                      Text('Example: ${wordData.example}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý lưu từ
                              _saveWord(wordData);
                            },
                            child: Text('Save'),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     _showReportDialog(wordData.sign!);
                          //   },
                          //   child: Text('Report'),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.red,
                          //   ),
                          // ),
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
