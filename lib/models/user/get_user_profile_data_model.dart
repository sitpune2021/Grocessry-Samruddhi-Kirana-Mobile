import 'dart:convert';
import 'package:flutter/foundation.dart';

GetUserProfileDataModel getUserProfileDataModelFromJson(String str) =>
    GetUserProfileDataModel.fromJson(json.decode(str));

String getUserProfileDataModelToJson(GetUserProfileDataModel data) =>
    json.encode(data.toJson());

@immutable
class GetUserProfileDataModel {
  final bool status;
  final Data data;

  const GetUserProfileDataModel({
    required this.status,
    required this.data,
  });

  factory GetUserProfileDataModel.fromJson(Map<String, dynamic> json) {
    return GetUserProfileDataModel(
      status: json["status"] as bool,
      data: Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };

  GetUserProfileDataModel copyWith({
    bool? status,
    Data? data,
  }) {
    return GetUserProfileDataModel(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

@immutable
class Data {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String mobile;
  final String? profilePhoto;
  final int status;
  final int roleId;
  final DateTime createdAt;

  const Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.mobile,
    this.profilePhoto,
    required this.status,
    required this.roleId,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] as int,
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      email: json["email"] as String?,
      mobile: json["mobile"] as String,
      profilePhoto: json["profile_photo"] as String?,
      status: json["status"] as int,
      roleId: json["role_id"] as int,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "profile_photo": profilePhoto,
        "status": status,
        "role_id": roleId,
        "created_at": createdAt.toIso8601String(),
      };

  Data copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? profilePhoto,
    int? status,
    int? roleId,
    DateTime? createdAt,
  }) {
    return Data(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      status: status ?? this.status,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
