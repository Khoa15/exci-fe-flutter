import 'package:exci_flutter/models/user_model.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:exci_flutter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement initState
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
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24),
            ),
            if (_user!.profilePictureUrl.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(_user!.profilePictureUrl),
                radius: 50,
              ),
            SizedBox(height: 16),
            Text(
              _user!.name,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _user!.email,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
