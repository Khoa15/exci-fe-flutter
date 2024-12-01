// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      listWords: (json['vocabs'] as List<dynamic>?)
          ?.map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
      // totalWords: (json['totalWords'] as num).toInt(),
      Active: (json['active'] as num?) == 1,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'vocabs': instance.listWords,
      // 'totalWords': instance.totalWords,
      'active': instance.Active
    };
