// To parse this JSON data, do
//
//     final showAlllEmplooyes = showAlllEmplooyesFromJson(jsonString);

import 'dart:convert';

List<ShowAlllEmplooyes> showAlllEmplooyesFromJson(String str) => List<ShowAlllEmplooyes>.from(json.decode(str).map((x) => ShowAlllEmplooyes.fromJson(x)));

String showAlllEmplooyesToJson(List<ShowAlllEmplooyes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowAlllEmplooyes {
  ShowAlllEmplooyes({
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

  factory ShowAlllEmplooyes.fromJson(Map<String, dynamic> json) => ShowAlllEmplooyes(
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
