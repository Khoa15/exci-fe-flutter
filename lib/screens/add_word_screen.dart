import 'dart:convert';

import 'package:exci_flutter/models/collection.dart';
import 'package:exci_flutter/models/pos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddWordScreen extends StatefulWidget {
  final int userId;

  AddWordScreen({required this.userId});

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _ipaController = TextEditingController();
  int? _selectedCollectionId;

  ListPos lstPOS = ListPos();
  List<Collection> _collections = [];
  @override
  void initState() {
    super.initState();
    _loadPosOptions();
    _loadCollections();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _ipaController.dispose();
    super.dispose();
  }

  Future<void> _loadPosOptions() async {
    // final url = Uri.parse('http://localhost:8000/pos');
    // try {
    //   final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    //   if (response.statusCode == 200) {
    //     List<dynamic> data = jsonDecode(response.body);
    //     setState(() {
    //       _posOptions = data.map((json) => POS.fromJson(json)).toList();// json.decode(response.body);
    //     });
    //   } else {
    //     print('Failed to load collections');
    //   }
    // } catch (error) {
    //   print('Error fetching collections: $error');
    // }
    // setState(() {
    //   _posOptions = lstPOS.listPos();
    // });
  }

  Future<void> _loadCollections() async {
    final url = Uri.parse('http://localhost:8000/collections/user/${widget.userId}');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _collections = data.map((json) => Collection.fromJson(json)).toList();// json.decode(response.body);
        });
      } else {
        print('Failed to load collections');
      }
    } catch (error) {
      print('Error fetching collections: $error');
    }
  }

  Future<void> _submitForm() async {
    print(_formKey.currentState);
    print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      if(! _exampleController.text.contains(_wordController.text)){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy từ trong ví dụ!')),
        );
        return;
      }
      // Xử lý logic thêm từ
      // print('Word: ${_wordController.text}');
      // print('Meaning: ${_meaningController.text}');
      // print('Example: ${_exampleController.text}');
      // print('IPA: ${_ipaController.text}');
      // print('POS: $_selectedPos');

      // Hiển thị thông báo thêm thành công
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Thêm từ thành công!')),
      // );
      
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/words/user'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "uid": widget.userId,
          "sign": _wordController.text,
          "pos": lstPOS.selectedPos,
          "collection_id": 0,
          "ipa": _ipaController.text,
          "sound": null,
          "meaning": _meaningController.text,
          "example": _exampleController.text,
          "level": "A1"
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add collection')),
        );
      }
      // Reset toàn bộ input
      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _wordController.clear();
    _meaningController.clear();
    _exampleController.clear();
    _ipaController.clear();
    // setState(() {
    //   _selectedPos = 'Noun';
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Từ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _wordController,
                decoration: InputDecoration(labelText: 'Từ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập từ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _meaningController,
                decoration: InputDecoration(labelText: 'Nghĩa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nghĩa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _exampleController,
                decoration: InputDecoration(labelText: 'Ví dụ'),
                validator: (value) =>
                    value == null ? 'Vui lòng nhập ví dụ' : null,
              ),
              TextFormField(
                controller: _ipaController,
                decoration: InputDecoration(labelText: 'IPA (Optional)'),
              ),
              // Part of Speech (POS)
              DropdownButtonFormField<Pos>(
                value: lstPOS.selectedPos,
                decoration: InputDecoration(labelText: 'Loại từ'),
                items: lstPOS.listPos.map((pos) {
                  return DropdownMenuItem(
                    value: pos,
                    child: Text(pos.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if(value != null){
                    setState(() {
                      lstPOS.selectedPos = value;
                    });
                  }
                },
                validator: (value) =>
                    value == null ? 'This field is required' : null,
              ),

              // Collection
              // DropdownButtonFormField<int>(
              //   value: _selectedCollectionId,
              //   decoration: InputDecoration(labelText: 'Collection (Optional)'),
              //   items: _collections.map((collection) {
              //     return DropdownMenuItem(
              //       value: collection.id,
              //       child: Text(collection.name),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedCollectionId = value;
              //     });
              //   },
              // ),

              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Thêm Từ'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nền của nút Cancel
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
