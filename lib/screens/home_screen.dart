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
import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/models/word_model.dart';
import 'package:exci_flutter/screens/word_list_screen.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<FolderModel> _folders = [
    FolderModel(name: 'Folder 1', listWord: [WordModel(word: 'apple'), WordModel(word: 'banana'), WordModel(word: 'Cherry')]),
    FolderModel(name: 'Folder 2', listWord: [WordModel(word: 'dog'), WordModel(word: 'cat'), WordModel(word: 'fish')]),
    FolderModel(name: 'Folder 3', listWord: [WordModel(word: 'red'), WordModel(word: 'blue'), WordModel(word: 'green')]),
  ];
  int _selectedIndex = 0;
  bool _isFabExpanded = false;

  // Controller để điều khiển hiệu ứng animation
  late AnimationController _animationController;
  late Animation<Color?> _animationColor;
  late Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationColor = ColorTween(
      begin: Colors.transparent,
      end: Colors.black54,
    ).animate(_animationController);

    _animationScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _folders.length,
          itemBuilder: (context, index) {
            final folder = _folders[index];
            return GestureDetector(
              onTap: () => _navigateToWordList(folder),
              child: Container(
                width: screenWidth, // Chiều rộng của folder bằng chiều rộng màn hình
                height: 150, // Chiều cao của folder (có thể điều chỉnh)
                margin: EdgeInsets.symmetric(vertical: 8.0), // Khoảng cách giữa các folder
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
                    // Spacer(),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: ElevatedButton(
                    //     onPressed: () => _navigateToWordList(folder),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.white, // Background color of the button
                    //       foregroundColor: Colors.blueAccent, // Text color of the button
                    //     ),
                    //     child: Text('Xem chi tiết'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
            floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_isFabExpanded) ...[
            // Nút Thêm A
            Positioned(
              bottom: 100.0,
              right: 16.0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _isFabExpanded ? 1.0 : 0.0,
                child: FloatingActionButton(
                  onPressed: () {
                    // Xử lý khi nhấn Thêm A
                  },
                  child: Text('A'),
                  heroTag: 'addA',
                  mini: true,
                ),
              ),
            ),
            // Nút Thêm B
            Positioned(
              bottom: 160.0,
              right: 16.0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _isFabExpanded ? 1.0 : 0.0,
                child: FloatingActionButton(
                  onPressed: () {
                    // Xử lý khi nhấn Thêm B
                  },
                  child: Text('B'),
                  heroTag: 'addB',
                  mini: true,
                ),
              ),
            ),
          ],
          // Nút chính "+"
          FloatingActionButton(
            onPressed: _toggleFab,
            child: Icon(_isFabExpanded ? Icons.close : Icons.add),
            heroTag: 'mainFAB',
          ),
        ],
      ),
          // AnimatedContainer(
          //   duration: Duration(milliseconds: 300),
          //   color: _isFabExpanded ? Colors.black.withOpacity(0.5) : Colors.transparent,
          // ),
          // Positioned(
          //   bottom: 16.0,
          //   right: 16.0,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // Nút thêm A
          //       if (_isFabExpanded) ...[
          //         ScaleTransition(
          //           scale: _animationScale,
          //           child: FloatingActionButton(
          //             onPressed: () {
          //               // Xử lý khi nhấn nút thêm A
          //             },
          //             child: Icon(Icons.add),
          //             tooltip: 'Thêm A',
          //             heroTag: 'addA',
          //           ),
          //         ),
          //         SizedBox(height: 8),
          //       ],
          //       // Nút thêm B
          //       if (_isFabExpanded) ...[
          //         ScaleTransition(
          //           scale: _animationScale,
          //           child: FloatingActionButton(
          //             onPressed: () {
          //               // Xử lý khi nhấn nút thêm B
          //             },
          //             child: Icon(Icons.add),
          //             tooltip: 'Thêm B',
          //             heroTag: 'addB',
          //           ),
          //         ),
          //         SizedBox(height: 8),
          //       ],
          //       // Nút chính
          //       FloatingActionButton(
          //         onPressed: _toggleFab,
          //         child: Icon(_isFabExpanded ? Icons.close : Icons.add),
          //         heroTag: 'mainFAB',
          //       ),
          //     ],
          //   ),
          // ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
