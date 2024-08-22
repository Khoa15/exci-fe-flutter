import 'package:exci_flutter/models/folder_model.dart';
import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget{
  final FolderModel folder;

  const WordListScreen({required this.folder});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: ListView.builder(
        itemCount: folder.listWord.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(folder.listWord[index].word),
          );
        },
      ),
    );
  }

}