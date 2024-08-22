import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier{
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthService(){
    _checkLoginStatus();
  }

  void _checkLoginStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login(String username, String password) async{
    // Xử lý đăng nhập
    // If thành công
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}