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
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              'Hello World',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // Hiển thị ảnh nền với hiệu ứng mở khi FAB được mở rộng
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: _isFabExpanded ? Colors.black.withOpacity(0.5) : Colors.transparent,
          ),
          // Vị trí FloatingActionButton chính
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nút thêm A
                if (_isFabExpanded) ...[
                  ScaleTransition(
                    scale: _animationScale,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút thêm A
                      },
                      child: Icon(Icons.add),
                      tooltip: 'Thêm A',
                      heroTag: 'addA',
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                // Nút thêm B
                if (_isFabExpanded) ...[
                  ScaleTransition(
                    scale: _animationScale,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút thêm B
                      },
                      child: Icon(Icons.add),
                      tooltip: 'Thêm B',
                      heroTag: 'addB',
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                // Nút chính
                FloatingActionButton(
                  onPressed: _toggleFab,
                  child: Icon(_isFabExpanded ? Icons.close : Icons.add),
                  heroTag: 'mainFAB',
                ),
              ],
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
