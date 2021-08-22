
import 'dart:convert';

ChangePassword changePasswordFromJson(String str) => ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  ChangePassword();

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
  );

  Map<String, dynamic> toJson() => {
  };
}