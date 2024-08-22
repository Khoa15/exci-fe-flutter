import 'package:flutter/material.dart';

class DictionaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
      ),
      body: Center(
        child: Text(
          'Dictionary',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
