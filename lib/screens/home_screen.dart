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
//           'Hello Word',
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
import 'dart:convert';
import 'dart:ui';

// import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/models/collection.dart';
import 'package:exci_flutter/models/user.dart';
import 'package:exci_flutter/models/word.dart';
import 'package:exci_flutter/screens/add_folder_dialog.dart';
import 'package:exci_flutter/screens/add_folder_screen.dart';
import 'package:exci_flutter/screens/add_word_screen.dart';
import 'package:exci_flutter/screens/practise_word_list_screen.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/utils/constants.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  User? _user;
  List<Collection> _collections = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
  bool _isFabExpanded = false;
  @override
  void initState() {
    super.initState();
    // _loadUser();
    _loadCollections();
  }

  void _navigateToWordList(Collection folder) {
    if(folder.Active == true) return;
    if (kIsWeb) {
      // Điều hướng trên web, ví dụ sử dụng Navigator hoặc chỉ định URL
      Navigator.pushNamed(context, '/folder/${folder.id}');
    } else {
      // Điều hướng trên mobile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WordListScreen(collectionId: folder.id),
        ),
      );
    }
  }

  Future<void> _loadCollections() async {
    try {
      await _loadUser();
      final url = Uri.parse('${host}/api/Collections/user/'+_user!.id.toString());
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        List<Collection> collections = jsonData.map((json) => Collection.fromJson(json)).toList();
        setState(() {
          _collections = collections;
          _isLoading = false;
        }); 
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
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

  void _showAddFolderDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddFolderScreen(userId: _user!.id), // Thay thế bằng màn hình thêm word của bạn
      ),
    );
  }

  void _navigateToAddWordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddWordScreen(userId: _user!.id), // Thay thế bằng màn hình thêm word của bạn
      ),
    ).then((result) {
      if (result == true) { // Kiểm tra nếu có thay đổi
        _loadCollections();
      }
    });
    // _loadCollections();
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
          onTap: _hideFab,
          child: 
          _collections.isEmpty == true ?
            Stack(
              children: [
                Center(child: Text('No collections found')),
                if (_isLoading) Center(child: CircularProgressIndicator()),
              ],
            )
          :
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    // _user?.role == 'standard'
                    // ? SystemFolder()
                    // :
                    //   DefaultTabController(
                    // length: 2,
                    // child: Column(
                    //   children: [
                    //     const TabBar(
                    //       tabs: [
                    //         Tab(text: 'Folder Hệ Thống'),
                    //         Tab(text: 'Folder Cá Nhân'),
                    //       ],
                    //     ),
                    //     Expanded(
                    //       child: //TabBarView(children: <Widget>[
                    _isLoading || _collections.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _collections.length,
                            itemBuilder: (context, index) {
                              final folder = _collections[index];
                              return GestureDetector(
                                onTap: () => _navigateToWordList(folder),
                                child: Container(
                                  width:
                                      screenWidth, // Chiều rộng của folder bằng chiều rộng màn hình
                                  height:
                                      150, // Chiều cao của folder (có thể điều chỉnh)
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          8.0), // Khoảng cách giữa các folder
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: folder.Active == true ? const Color.fromARGB(255, 192, 238, 207) : Colors.blueAccent,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      // Text(
                                      //   '${folder.totalWords} words',
                                      //   style: TextStyle(
                                      //     color: Colors.white70,
                                      //     fontSize: 14,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                // SystemFolder()
                //]),
                //         ),
                //       ],
                //     ),
                //   ),
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
                onPressed: () => _navigateToWordList(Collection(id: -1, name: "Revise")),
                heroTag: 'learn',
                shape: CircleBorder(),
                mini: true,
                child: const Icon(Icons.school),
              ),
            ),
          ),
          if (1 == 1) //_user?.role == 'premium')
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
                    // AnimatedOpacity(
                    //   duration: const Duration(milliseconds: 100),
                    //   opacity: _isFabExpanded ? 1.0 : 0.0,
                    //   child: FloatingActionButton(
                    //     onPressed: _showAddFolderDialog,
                    //     heroTag: 'addFolder',
                    //     shape: CircleBorder(),
                    //     mini: true,
                    //     child: const Icon(Icons.folder),
                    //   ),
                    // ),
                    SizedBox(height: 16.0), // Khoảng cách giữa các nút
                  ],
                  // Nút chính "+"
                  FloatingActionButton(
                    onPressed: _toggleFab,
                    heroTag: 'mainFAB',
                    shape: CircleBorder(),
                    mini: true,
                    child: Icon(_isFabExpanded ? Icons.close : Icons.add),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// class SystemFolder extends StatelessWidget {
//   // final List<Collection> _folders = [
//   //   Collection(id: 1, name: 'Folder 1', listWord: [
//   //     Word(id: 1, sign: 'apple'),
//   //     Word(id: 1, sign: 'banana'),
//   //     Word(id: 1, sign: 'Cherry')
//   //   ]),
//   //   Collection(id: 1, name: 'Folder 2', listWord: [
//   //     Word(id: 1, sign: 'dog'),
//   //     Word(id: 1, sign: 'cat'),
//   //     Word(id: 1, sign: 'fish')
//   //   ]),
//   //   Collection(id: 1, name: 'Folder 3', listWord: [
//   //     Word(id: 1, sign: 'red'),
//   //     Word(id: 1, sign: 'blue'),
//   //     Word(id: 1, sign: 'green')
//   //   ]),
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     void _navigateToWordList(Collection folder) {
//       if (kIsWeb) {
//         // Điều hướng trên web, ví dụ sử dụng Navigator hoặc chỉ định URL
//         Navigator.pushNamed(context, '/folder/${folder.name}');
//       } else {
//         // Điều hướng trên mobile
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => WordListScreen(collection: folder),
//           ),
//         );
//       }
//     }

//     return ListView.builder(
//       itemCount: _collections.length,
//       itemBuilder: (context, index) {
//         final folder = _folders[index];
//         return GestureDetector(
//           onTap: () => _navigateToWordList(folder),
//           child: Container(
//             width:
//                 screenWidth, // Chiều rộng của folder bằng chiều rộng màn hình
//             height: 150, // Chiều cao của folder (có thể điều chỉnh)
//             margin: EdgeInsets.symmetric(
//                 vertical: 8.0), // Khoảng cách giữa các folder
//             padding: EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4.0,
//                   spreadRadius: 2.0,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   folder.name,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   '${folder.listWord.length} words',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
