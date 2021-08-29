// To parse this JSON data, do
//
//     final birthdays = birthdaysFromJson(jsonString);

import 'dart:convert';

List<Birthdays> birthdaysFromJson(String str) => List<Birthdays>.from(json.decode(str).map((x) => Birthdays.fromJson(x)));

String birthdaysToJson(List<Birthdays> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Birthdays {
  Birthdays({
    required this.applicationUserId,
    required this.birthday,
    required this.fullName,
  });

  String applicationUserId;
  DateTime birthday;
  String fullName;

  factory Birthdays.fromJson(Map<String, dynamic> json) => Birthdays(
    applicationUserId: json["applicationUserId"],
    birthday: DateTime.parse(json["birthday"]),
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "applicationUserId": applicationUserId,
    "birthday": birthday.toIso8601String(),
    "fullName": fullName,
  };
}