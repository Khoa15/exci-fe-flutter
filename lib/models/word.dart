import 'package:equatable/equatable.dart';

import 'collection.dart';

part 'word.g.dart';

// @JsonSerializable()
class Word extends Equatable {
  final int id;
  final String? sign;
  final String? pos;
  final int? collectionId;
  final String? ipa;
  final String? sound;
  final String? meaning;
  final String? example;
  final String? level;

  // Relationships
  Collection? collection;

  Word(
      {required this.id,
      this.sign,
      this.pos,
      this.collectionId,
      this.ipa,
      this.sound,
      this.meaning,
      this.example,
      this.collection,
      this.level,});

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
  Map<String, dynamic> toJson() => _$WordToJson(this);

  @override
  List<Object?> get props => [id, sign, pos];
}
