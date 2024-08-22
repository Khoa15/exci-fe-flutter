import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input fields, buttons
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng ký
                // Sau khi đăng ký thành công, điều hướng về trang đăng nhập
                Navigator.pop(context);
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
