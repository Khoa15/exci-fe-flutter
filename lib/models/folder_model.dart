import 'package:exci_flutter/models/word_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'folder_model.g.dart';

@JsonSerializable()
class FolderModel {
  final String name;
  final List<WordModel> listWord;

  FolderModel({
    required this.name,
    required this.listWord
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) => _$FolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}