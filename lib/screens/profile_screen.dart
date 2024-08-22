import 'package:exci_flutter/models/user_model.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadUser();
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

  Future<void> _loadUser() async {
    UserModel? user = await getUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    if(_isLoading){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _user == null ? 
      Center(child: Text("Không tìm thấy thông tin người dùng"),)
      :
      Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blueGrey[100],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_user!.profilePictureUrl),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                        children: [
                          Expanded(
                            child: Text(
                              _user!.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Xử lý khi nhấn vào nút tròn
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Nút tròn nhấn')),
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                            iconSize: 20.0,
                          ),
                        ],
                      ),
                        Text(
                          '@${_user!.email}',
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        Text(
                          'Level: ${_user!.id}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn vào nút 1
                    },
                    child: Text('Xem xếp hạng'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn vào nút 2
                    },
                    child: Text('Phân tích chỉ số nhớ'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn vào nút 3
                    },
                    child: Text('Góp ý & phản hồn'),
                  ),
                  // Thêm các nút khác nếu cần
                ],
              ),
            ),
            // Nút Đăng xuất
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn vào nút Đăng xuất
                  // Ví dụ: Điều hướng về màn hình đăng nhập hoặc thực hiện logout
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu nền của nút Đăng xuất
                  foregroundColor: Colors.white, // Màu chữ của nút Đăng xuất
                ),
                child: Text('Đăng xuất'),
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
