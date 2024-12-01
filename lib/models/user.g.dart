// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      role: json['role'] as String?,
      updatedAt: json['updateD_AT'] == null
          ? null
          : DateTime.parse(json['updateD_AT'] as String),
      createdAt: json['createD_AT'] == null
          ? null
          : DateTime.parse(json['createD_AT'] as String),
      wordStats: (json['userVocabs'] as List<dynamic>?)
          ?.map((e) => WordStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      sectionLearnings: (json['sectionLearnings'] as List<dynamic>?)
          ?.map((e) => SectionLearning.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      // 'request': instance.request,
      // 'requestDate': instance.requestDate?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'wordStats': instance.wordStats,
      'sectionLearnings': instance.sectionLearnings,
    };
