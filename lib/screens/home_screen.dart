// import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     if (index != _selectedIndex) {
//       setState(() {
//         _selectedIndex = index;
//       });

//       switch (index) {
//         case 0:
//           Navigator.pushReplacementNamed(context, '/home');
//           break;
//         case 1:
//           Navigator.pushReplacementNamed(context, '/vocabulary');
//           break;
//         case 2:
//           Navigator.pushReplacementNamed(context, '/profile');
//           break;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Hello World',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/models/user_model.dart';
import 'package:exci_flutter/models/word_model.dart';
import 'package:exci_flutter/screens/add_word_screen.dart';
import 'package:exci_flutter/screens/word_list_screen.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final UserModel? _user;
  final List<FolderModel> _folders = [
    FolderModel(name: 'Folder 1', listWord: [
      WordModel(word: 'apple'),
      WordModel(word: 'banana'),
      WordModel(word: 'Cherry')
    ]),
    FolderModel(name: 'Folder 2', listWord: [
      WordModel(word: 'dog'),
      WordModel(word: 'cat'),
      WordModel(word: 'fish')
    ]),
    FolderModel(name: 'Folder 3', listWord: [
      WordModel(word: 'red'),
      WordModel(word: 'blue'),
      WordModel(word: 'green')
    ]),
  ];
  int _selectedIndex = 0;
  bool _isFabExpanded = false;
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    UserModel? user = await getUser();
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

  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Folder'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Tên Folder'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Xử lý thêm folder
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddWordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddWordScreen(), // Thay thế bằng màn hình thêm word của bạn
      ),
    );
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
    });
  }

  void _hideFab() {
    if (_isFabExpanded) {
      setState(() {
        _isFabExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: _hideFab,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _user?.accountType == 'standard'
                    ? SystemFolder()
                    : DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Folder Hệ Thống'),
                                Tab(text: 'Folder Cá Nhân'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(children: <Widget>[
                                SystemFolder(),
                                SystemFolder()
                              ]),
                            ),
                          ],
                        ),
                      ),
              ),
              if (_isFabExpanded)
                AnimatedOpacity(
                  opacity: _isFabExpanded ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
            ],
          )),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {},
                heroTag: 'learn',
                shape: CircleBorder(),
                mini: true,
                child: const Icon(Icons.school),
              ),
            ),
          ),
          if (_user?.accountType == 'premium')
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_isFabExpanded) ...[
                    // Nút Thêm A
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: _isFabExpanded ? 1.0 : 0.0,
                      child: FloatingActionButton(
                        onPressed: _navigateToAddWordScreen,
                        heroTag: 'addWord',
                        shape: CircleBorder(),
                        mini: true,
                        child: const Icon(Icons.add),
                      ),
                    ),
                    SizedBox(height: 16.0), // Khoảng cách giữa các nút
                    // Nút Thêm B
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: _isFabExpanded ? 1.0 : 0.0,
                      child: FloatingActionButton(
                        onPressed: _showAddFolderDialog,
                        heroTag: 'addFolder',
                        shape: CircleBorder(),
                        mini: true,
                        child: const Icon(Icons.folder),
                      ),
                    ),
                    SizedBox(height: 16.0), // Khoảng cách giữa các nút
                  ],
                  // Nút chính "+"
                  FloatingActionButton(
                    onPressed: _toggleFab,
                    child: Icon(_isFabExpanded ? Icons.close : Icons.add),
                    heroTag: 'mainFAB',
                    shape: CircleBorder(),
                    mini: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SystemFolder extends StatelessWidget {
  final List<FolderModel> _folders = [
    FolderModel(name: 'Folder 1', listWord: [
      WordModel(word: 'apple'),
      WordModel(word: 'banana'),
      WordModel(word: 'Cherry')
    ]),
    FolderModel(name: 'Folder 2', listWord: [
      WordModel(word: 'dog'),
      WordModel(word: 'cat'),
      WordModel(word: 'fish')
    ]),
    FolderModel(name: 'Folder 3', listWord: [
      WordModel(word: 'red'),
      WordModel(word: 'blue'),
      WordModel(word: 'green')
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    void _navigateToWordList(FolderModel folder) {
      if (kIsWeb) {
        // Điều hướng trên web, ví dụ sử dụng Navigator hoặc chỉ định URL
        Navigator.pushNamed(context, '/folder/${folder.name}');
      } else {
        // Điều hướng trên mobile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordListScreen(folder: folder),
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return GestureDetector(
          onTap: () => _navigateToWordList(folder),
          child: Container(
            width:
                screenWidth, // Chiều rộng của folder bằng chiều rộng màn hình
            height: 150, // Chiều cao của folder (có thể điều chỉnh)
            margin: EdgeInsets.symmetric(
                vertical: 8.0), // Khoảng cách giữa các folder
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${folder.listWord.length} words',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
