// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  UserLoginModel({
    required this.token,
    required this.expiration,
    required this.id,
     required this.userResource,
  });


  String token;
  DateTime expiration;
  String id;
  UserResource userResource;

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
    token: json["token"],
    expiration: DateTime.parse(json["expiration"]),
    id: json["id"],
    userResource: UserResource.fromJson(json["userResource"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expiration": expiration.toIso8601String(),
    "id": id,
    "userResource": userResource.toJson(),
  };
}

class UserResource {
  UserResource({
    required this.id,
    required this.fullName,
    required this.email,
    required this.birthday,
    required this.officeId,
    required this.departmentId,
  });

  String id;
  String fullName;
  String email;
  DateTime birthday;
  int officeId;
  int departmentId;

  factory UserResource.fromJson(Map<String, dynamic> json) => UserResource(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    birthday: DateTime.parse(json["birthday"]),
    officeId: json["officeId"],
    departmentId: json["departmentId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "birthday": birthday.toIso8601String(),
    "officeId": officeId,
    "departmentId": departmentId,
  };
}