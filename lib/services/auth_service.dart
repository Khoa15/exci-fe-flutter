import 'dart:convert';

import 'package:exci_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
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
    UserModel userModel = new UserModel(id: "123", name: "Khoa", password: '', email: "hp09.com@gmail.com");
    String userJson = jsonEncode(userModel.toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString("user", userJson);
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