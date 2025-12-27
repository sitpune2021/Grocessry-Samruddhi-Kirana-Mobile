// To parse this JSON data, do
//
//     final UserModel = UserModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final bool status;
  final String message;
  final String token;
  final String tokenType;
  final User user;

  UserModel({
    required this.status,
    required this.message,
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json["status"] == true || json["status"] == 1,
      message: json["message"] ?? "",
      token: json["token"] ?? "",
      tokenType: json["token_type"] ?? "",
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "token": token,
    "token_type": tokenType,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String? email;
  final int roleId;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    this.email,
    required this.roleId,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json["id"].toString()) ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"],
      roleId: int.tryParse(json["role_id"].toString()) ?? 0,
      role: json["role"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "mobile": mobile,
    "email": email,
    "role_id": roleId,
    "role": role,
  };
}
