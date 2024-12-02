// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordStat _$WordStatFromJson(Map<String, dynamic> json) => WordStat(
      wordId: (json['word_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      // nSteak: (json['n_steak'] as num).toInt(),
      // nMaxSteak: (json['n_max_steak'] as num).toInt(),
      memoryStat: (json['memory_stat'] as num).toInt(),
      nListening: (json['n_listening'] as num).toInt(),
      nFListening: (json['n_f_listening'] as num).toInt(),
      nReading: (json['n_reading'] as num).toInt(),
      nFReading: (json['n_f_reading'] as num).toInt(),
      nWriting: (json['n_writing'] as num).toInt(),
      nFWriting: (json['n_f_writing'] as num).toInt(),
      // nSpeaking: (json['n_speaking'] as num).toInt(),
      // nFSpeaking: (json['n_f_speaking'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      // updatedAt: DateTime.parse(json['updated_at'] as String),
      expectedAt: DateTime.parse(json['expected_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      word: json['word'] == null
          ? null
          : Word.fromJson(json['word'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WordStatToJson(WordStat instance) => <String, dynamic>{
      'word_id': instance.wordId,
      'user_id': instance.userId,
      // 'n_streak': instance.nSteak,
      // 'n_max_streak': instance.nMaxSteak,
      'memory_stat': instance.memoryStat,
      'n_listening': instance.nListening,
      'n_f_listening': instance.nFListening,
      'n_reading': instance.nReading,
      'n_f_reading': instance.nFReading,
      'n_writing': instance.nWriting,
      'n_f_writing': instance.nFWriting,
      // 'n_speaking': instance.nSpeaking,
      // 'n_f_speaking': instance.nFSpeaking,
      'created_at': instance.createdAt?.toIso8601String(),
      // 'updated_at': instance.updatedAt?.toIso8601String(),
      'expected_at': instance.expectedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'word': instance.word?.toJson(),
    };
Map<String, dynamic> _$WordStatInsertToJson(
        WordStat instance, int total, int n_true) =>
    <String, dynamic>{
      'word_id': instance.wordId,
      'user_id': instance.userId,
      // 'n_streak': instance.nSteak,
      // 'n_max_streak': instance.nMaxSteak,
      'memory_stat': instance.memoryStat,
      'n_listening': instance.nListening,
      'n_f_listening': instance.nFListening,
      'n_reading': instance.nReading,
      'n_f_reading': instance.nFReading,
      'n_writing': instance.nWriting,
      'n_f_writing': instance.nFWriting,
      // 'n_speaking': instance.nSpeaking,
      // 'n_f_speaking': instance.nFSpeaking,
      'created_at': instance.createdAt?.toIso8601String(),
      // 'updated_at': instance.updatedAt?.toIso8601String(),
      'expected_at': instance.expectedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'word': instance.word?.toJson(),
    };
