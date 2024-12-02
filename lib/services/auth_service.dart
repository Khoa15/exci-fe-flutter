import 'dart:convert';

import 'package:exci_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<User?> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');
  if (userJson != null) {
    return User.fromJson(jsonDecode(userJson));
  }
  return null;
}

class AuthService with ChangeNotifier {
  String hostname = 'https://localhost:7235';
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('${hostname}/api/Users/sign-in');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        String userJson = jsonEncode(user.toJson());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString("user", userJson);
        print(userJson);
        _isLoggedIn = true;
        notifyListeners();
        return true; // Đăng nhập thành công
      } else {
        // Nếu đăng nhập thất bại, bạn có thể xử lý ở đây
        return false; // Đăng nhập không thành công
      }
    } catch (error) {
      // Xử lý lỗi mạng hoặc lỗi khác
      print('Error: $error');
      return false;
    }
  }

  Future<void> SendRequestForgotPassword(String email) async {
    try{
      final response = await http.get(Uri.parse('${hostname}/api/Users/reset-password/${email}'));
      if(response.statusCode != 200){
        throw Exception("Có lỗi!");
      }
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
