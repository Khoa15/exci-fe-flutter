import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'section_learning.dart';
import 'word_stat.dart';

part 'user.g.dart';

// @JsonSerializable()
class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? password;
  final String? role;
  // final String? request;
  // final DateTime? requestDate;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  // Relationships
  List<WordStat>? wordStats;
  List<SectionLearning>? sectionLearnings;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    required this.role,
    // this.request,
    // this.requestDate,
    this.updatedAt,
    this.createdAt,
    this.wordStats,
    this.sectionLearnings,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username, email, role];

  Future<List<UserRank>?> GetListRank()async{
    try{
      var response = await http.get(Uri.parse("https://localhost:7235/api/Users/list-rank"));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        List<UserRank> listUserRank = jsonData.map((json) => UserRank.fromJson(json)).toList();
        return listUserRank;
      }
    }catch(error){
      print(error);
    }
    return null;
  }
}
class UserRank{
  late int id;
  late String username;
  late double memory_stat;
  UserRank({
    required this.id,
    required this.username,
    required this.memory_stat
  });  
  factory UserRank.fromJson(Map<String, dynamic> json) => UserRank(
        id: (json['userId'] as num).toInt(),
        username: json['username'] as String,
        memory_stat: json['avgMemoryStat'] as double,
      );
}