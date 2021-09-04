// To parse this JSON data, do
//
//     final toRegisterModel = toRegisterModelFromJson(jsonString);

import 'dart:convert';

ToRegisterModel toRegisterModelFromJson(String str) => ToRegisterModel.fromJson(json.decode(str));

String toRegisterModelToJson(ToRegisterModel data) => json.encode(data.toJson());

class ToRegisterModel {
  ToRegisterModel({
    required this.email,
  });

  String email;

  factory ToRegisterModel.fromJson(Map<String, dynamic> json) => ToRegisterModel(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}