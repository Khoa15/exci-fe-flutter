// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
      word: json['word'] as String,
      ipa: json['ipa'] as String? ?? '',
      pos: json['pos'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
    );

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      'word': instance.word,
      'ipa': instance.ipa,
      'pos': instance.pos,
      'meaning': instance.meaning,
      'example': instance.example,
      'audio': instance.audio,
    };
