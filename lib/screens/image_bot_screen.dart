import 'dart:convert';
import 'dart:typed_data';
// ignore: deprecated_member_use
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class ImageBotScreen extends StatefulWidget {
  @override
  _ImageBotScreenState createState() => _ImageBotScreenState();
}

class _ImageBotScreenState extends State<ImageBotScreen> {

  Uint8List? _imageBytes;
  String _result = "No result yet.";
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((event) {
        setState(() {
          _imageBytes = reader.result as Uint8List;
        });
      });
    });
  }

  Future<void> _uploadImage() async {
    if(_isLoading == true) return;
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      const apiUrl = 'http://localhost:11434/api/chat'; // Thay bằng URL API của bạn
      String base64img = base64Encode(_imageBytes!);
      final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "model": "assistant-searcher-vocab",
            "messages":[
              {
                "role": "user",
                "content": "",
                "images": [base64img]
              }
            ],
            "stream": false,
            "raw": true,
            "keep_alive": 0,
            "max_tokens": 256,
            }),
        );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = data["message"]["content"]; // Thay đổi theo cấu trúc JSON của API
        });
      } else {
        setState(() {
          _result = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_imageBytes != null)
                  Image.memory(
                    _imageBytes!,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: Text('No image selected'),
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.upload_file),
                  label: Text('Select Image'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Upload Image'),
                ),
                SizedBox(height: 16),
                Text(
                  'Result:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  _result,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
