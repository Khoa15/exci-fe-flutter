import 'package:exci_flutter/models/word.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFolderScreen extends StatefulWidget {
  final int userId;

  const AddFolderScreen({super.key, required this.userId});

  @override
  _AddFolderScreenState createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  String folderName = '';
  List<Word> words = [];
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
      Uri.parse('http://127.0.0.1:8000/collections/user'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": folderName,
        "uid": widget.userId,
        "idWords": selectedWordIds,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add collection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm bộ"),
      ),
      body: Column(
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
                  child: 
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of columns in the grid
                      mainAxisSpacing: 1, // Vertical spacing between grid items
                      crossAxisSpacing: 0, // Horizontal spacing between grid items
                      childAspectRatio: 15, // Adjust aspect ratio to fit the CheckboxListTile format
                    ),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(words[index].sign ?? ''),
                        value: selectedWordIds.contains(words[index].id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedWordIds.add(words[index].id);
                            } else {
                              selectedWordIds.remove(words[index].id);
                            }
                          });
                        },
                      );
                    },
                  )

                  // ListView.builder(  
                  //   itemCount: words.length,
                  //   itemBuilder: (context, index) {
                  //     return CheckboxListTile(
                  //       title: Text(words[index].sign ?? ''),
                  //       value: selectedWordIds.contains(words[index].id),
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           if (value == true) {
                  //             selectedWordIds.add(words[index].id);
                  //           } else {
                  //             selectedWordIds.remove(words[index].id);
                  //           }
                  //         });
                  //       },
                  //     );
                  //   },
                  // ),
                ),
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
      ),
    );
  }
}