import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'user.dart';
import 'word.dart';

part 'word_stat.g.dart';

// @JsonSerializable()
class WordStat extends Equatable {
  final int wordId;
  final int userId;
  int memoryStat;
  int nListening;
  int nFListening;
  int nReading;
  int nFReading;
  int nWriting;
  int nFWriting;
  final DateTime? createdAt;
  DateTime? expectedAt;

  // Relationships
  User? user;
  Word? word;

  WordStat({
    required this.wordId,
    required this.userId,
    // required this.nSteak,
    // required this.nMaxSteak,
    required this.memoryStat,
    required this.nListening,
    required this.nFListening,
    required this.nReading,
    required this.nFReading,
    required this.nWriting,
    required this.nFWriting,
    // required this.nSpeaking,
    // required this.nFSpeaking,
    this.createdAt,
    // this.updatedAt,
    this.expectedAt,
    this.user,
    this.word,
  });

  factory WordStat.fromJson(Map<String, dynamic> json) =>
      _$WordStatFromJson(json);

  Map<String, dynamic> toJson() => _$WordStatToJson(this);
  Map<String, dynamic> toInsertRequestJson(int total, int nTrue) =>
      _$WordStatInsertToJson(this, total, nTrue);

  @override
  List<Object?> get props => [wordId, userId];

  void CalculateMemoryStat() {
    memoryStat = 1;
    expectedAt = DateTime.now();

    expectedAt = expectedAt?.add(const Duration(days: 10));
  }
}
