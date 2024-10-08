import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String accountType;
  final String profilePictureUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.accountType,
    this.profilePictureUrl = '',
  });

  // Hàm chuyển từ JSON thành UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // Hàm chuyển từ UserModel thành JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
