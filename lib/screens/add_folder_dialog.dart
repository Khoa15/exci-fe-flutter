import 'package:exci_flutter/models/word.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFolderDialog extends StatefulWidget {
  final int userId;

  const AddFolderDialog({super.key, required this.userId});

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  String folderName = '';
  List<dynamic> words = [];
  List<int> selectedWordIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/words'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      setState(() {
        words = jsonData.map((json) => Word.fromJson(json)).toList();// json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error response
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load words')),
      );
    }
  }

  void addFolder() async {
    if (folderName.isEmpty || selectedWordIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder name and at least one word required')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/words/user'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": folderName,
        "uid": widget.userId,
        "words": selectedWordIds,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add collection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Tên Folder'),
            onChanged: (value) {
              setState(() {
                folderName = value;
              });
            },
          ),
          SizedBox(height: 10),
          isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      // return CheckboxListTile(
                      //   title: Text(words[index]['sign'] ?? ''),
                      //   value: selectedWordIds.contains(words[index]['id']),
                      //   onChanged: (bool? value) {
                      //     setState(() {
                      //       if (value == true) {
                      //         selectedWordIds.add(words[index]['id']);
                      //       } else {
                      //         selectedWordIds.remove(words[index]['id']);
                      //       }
                      //     });
                      //   },
                      // );
                      return CheckboxListTile(
                        title: Text("123"),
                        value: selectedWordIds.contains("123"),
                        onChanged: (bool? value) {
                          // setState(() {
                          //   if (value == true) {
                          //     selectedWordIds.add(words[index]['id']);
                          //   } else {
                          //     selectedWordIds.remove(words[index]['id']);
                          //   }
                          // });
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: addFolder,
          child: Text('Thêm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy'),
        ),
      ],
    );
  }
}