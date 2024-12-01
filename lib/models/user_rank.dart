import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserRank {
  late int id;
  late String username;
  late double AvgMemoryStat;

  UserRank({
    required this.id,
    required this.username,
    required this.AvgMemoryStat
  });
}