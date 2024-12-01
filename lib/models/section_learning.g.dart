// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_learning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionLearning _$SectionLearningFromJson(Map<String, dynamic> json) =>
    SectionLearning(
      id: (json['id'] as num).toInt(),
      userId: (json['uid'] as num).toInt(),
      timeLearn: (json['timeLearn'] as num).toInt(),
      nTotalWords: (json['nTotalWords'] as num).toInt(),
      nWordWrongAnswers: (json['n_f_answers'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SectionLearningToJson(SectionLearning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timeLearn': instance.timeLearn,
      'nTotalWords': instance.nTotalWords,
      'nWordsTrue': instance.nWordWrongAnswers,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
    };
