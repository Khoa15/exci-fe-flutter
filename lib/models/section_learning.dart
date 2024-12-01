import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'user.dart';

part 'section_learning.g.dart';

// @JsonSerializable()
class SectionLearning extends Equatable {
  final int id;
  final int userId;
  final int timeLearn;
  final int nTotalWords;
  final int nWordWrongAnswers;
  final DateTime createdAt;

  // Relationships
  User? user;

  SectionLearning({
    required this.id,
    required this.userId,
    required this.timeLearn,
    required this.nTotalWords,
    required this.nWordWrongAnswers,
    required this.createdAt,
    this.user,
  });

  factory SectionLearning.fromJson(Map<String, dynamic> json) =>
      _$SectionLearningFromJson(json);
  Map<String, dynamic> toJson() => _$SectionLearningToJson(this);

  @override
  List<Object?> get props => [id, userId];
}
