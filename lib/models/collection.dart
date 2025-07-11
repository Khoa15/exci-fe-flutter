import 'package:exci_flutter/models/word.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'collection.g.dart';

// @JsonSerializable()
class Collection extends Equatable {
  final int id;
  final String name;
  final List<Word>? listWords;
  // final int totalWords;
  final bool? Active;

  const Collection({
    required this.id,
    required this.name,
    this.listWords,
    // this.totalWords = 0,
    this.Active = false
  });

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  @override
  List<Object?> get props => [id, name];
}
