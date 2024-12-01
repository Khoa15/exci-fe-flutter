// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      id: (json['id'] as num).toInt(),
      sign: json['word'] as String?,
      pos: json['pos'] as String?,
      collectionId: (json['collectionID'] as num?)?.toInt(),
      ipa: json['ipa'] as String?,
      sound: json['audioURL'] as String?,
      meaning: json['meanings'] as String?,
      example: json['example'] as String?,
      collection: json['collection'] == null
          ? null
          : Collection.fromJson(json['collection'] as Map<String, dynamic>),
      level: json['level'] as String?,
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'id': instance.id,
      'sign': instance.sign,
      'pos': instance.pos,
      'collectionId': instance.collectionId,
      'ipa': instance.ipa,
      'sound': instance.sound,
      'meaning': instance.meaning,
      'example': instance.example,
      'level': instance.level,
      'collection': instance.collection,
    };

