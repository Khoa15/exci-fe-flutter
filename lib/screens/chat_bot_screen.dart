import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class ChatBotApp extends StatelessWidget {
//   // @override
//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     debugShowCheckedModeBanner: false,
//   //     home: ChatScreen(),
//   //   );
//   // }
//   @override

// }

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isLoading = true;
    });

    // Gọi API để lấy phản hồi
    final response = await _fetchResponse(message);

    setState(() {
      _isLoading = false;
      if (response != null) {
        _messages.add({'sender': 'bot', 'text': response});
      } else {
        _messages.add({'sender': 'bot', 'text': 'Sorry, something went wrong!'});
      }
    });
  }

  Future<String?> _fetchResponse(String message) async {
    const apiUrl = 'http://localhost:11434/api/chat'; // Thay bằng URL API thực

// # data = {
// #     "model": "llama3.2",
// #     "prompt": "Just give only one word in your answer. What is part of speech 'house'?",
// #     "stream": False,
// #     "raw": True,
// #     "keep_alive": 0
// # }
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "user-assistant",
          "messages":[
            {
              "role":"user",
              "content": message
            }
          ],
          "stream": false,
          "raw": true,
          "max_tokens": 256,
          "options": {
            "num_ctx": 512,
            "mirostat_eta": 0.5
          }
          }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["message"]["content"];//data['response']; // Thay đổi theo cấu trúc JSON của API
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Container(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty && _isLoading == false) {
                      _sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}