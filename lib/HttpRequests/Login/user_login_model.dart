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
    required this.user,
  });

  String token;
  DateTime expiration;
  String id;
  User user;

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
    token: json["token"],
    expiration: DateTime.parse(json["expiration"]),
    id: json["id"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expiration": expiration.toIso8601String(),
    "id": id,
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.birthday,
    required this.email,
    this.password,
    required this.fullName,
    this.events,
  });

  DateTime birthday;
  String email;
  dynamic password;
  String fullName;
  dynamic events;

  factory User.fromJson(Map<String, dynamic> json) => User(
    birthday: DateTime.parse(json["birthday"]),
    email: json["email"],
    password: json["password"],
    fullName: json["fullName"],
    events: json["events"],
  );

  Map<String, dynamic> toJson() => {
    "birthday": birthday.toIso8601String(),
    "email": email,
    "password": password,
    "fullName": fullName,
    "events": events,
  };
}
