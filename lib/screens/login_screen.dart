import 'dart:convert';

import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Future<void> _registerUser() async {
  //   final String email = _emailController.text;
  //   final String password = _passwordController.text;

  //   // Lấy URL từ biến môi trường
  //   final String url = 'http://localhost:8000/users/';
  //   var client = new http.Client();
  //   try {
  //     final response = await client.post(
  //         Uri.parse(url),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode({'email': email, 'password': password}),
  //       );

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Đăng ký thành công!')),
  //       );
  //       Navigator.pop(context);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Đã xảy ra lỗi!')),
  //       );
  //       print('Lỗi: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Đã xảy ra lỗi!')),
  //       );
  //     print('Đã xảy ra lỗi: $e');
  //   } finally{
  //     client.close();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  await authService.login(email, password);
                  // Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Tạo tài khoản'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: Text('Quên mật khẩu?'),
            ),
          ],
        ),
      ),
    );
  }
}
