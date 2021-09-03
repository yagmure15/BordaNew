// To parse this JSON data, do
//
//     final anasayfaDenemeModel = anasayfaDenemeModelFromJson(jsonString);

import 'dart:convert';

AnasayfaDenemeModel anasayfaDenemeModelFromJson(String str) => AnasayfaDenemeModel.fromJson(json.decode(str));

String anasayfaDenemeModelToJson(AnasayfaDenemeModel data) => json.encode(data.toJson());

class AnasayfaDenemeModel {
  AnasayfaDenemeModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.area,
    required this.address,
  });

  int id;
  String name;
  int capacity;
  int area;
  String address;

  factory AnasayfaDenemeModel.fromJson(Map<String, dynamic> json) => AnasayfaDenemeModel(
    id: json["id"],
    name: json["name"],
    capacity: json["capacity"],
    area: json["area"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "capacity": capacity,
    "area": area,
    "address": address,
  };
}
