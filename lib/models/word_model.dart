import 'package:json_annotation/json_annotation.dart';

part 'word_model.g.dart';

@JsonSerializable()
class WordModel {
  final String word;
  final String ipa;
  final String pos;
  final String meaning;
  final String example;
  final String audio;

  WordModel({
    required this.word,
    this.ipa = '',
    this.pos = '',
    this.meaning = '',
    this.example = '',
    this.audio = ''
  });

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}