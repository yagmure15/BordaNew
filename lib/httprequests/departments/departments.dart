// To parse this JSON data, do
//
//     final departments = departmentsFromJson(jsonString);

import 'dart:convert';

List<Departments> departmentsFromJson(String str) => List<Departments>.from(json.decode(str).map((x) => Departments.fromJson(x)));

String departmentsToJson(List<Departments> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Departments {
  Departments({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
