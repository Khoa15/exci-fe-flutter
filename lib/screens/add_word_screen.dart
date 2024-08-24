import 'package:flutter/material.dart';

class AddWordScreen extends StatefulWidget {
  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _ipaController = TextEditingController();
  String _selectedPos = 'Noun';

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _ipaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Xử lý logic thêm từ
      print('Word: ${_wordController.text}');
      print('Meaning: ${_meaningController.text}');
      print('Example: ${_exampleController.text}');
      print('IPA: ${_ipaController.text}');
      print('POS: $_selectedPos');

      // Hiển thị thông báo thêm thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm từ thành công!')),
      );

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
    setState(() {
      _selectedPos = 'Noun';
    });
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
              ),
              TextFormField(
                controller: _ipaController,
                decoration: InputDecoration(labelText: 'IPA'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPos,
                decoration: InputDecoration(labelText: 'Loại từ'),
                items: <String>['Noun', 'Verb', 'Adjective', 'Adverb', 'Pronoun', 'Preposition', 'Conjunction', 'Interjection']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPos = newValue!;
                  });
                },
              ),
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
