// To parse this JSON data, do
//
//     final officeListModel = officeListModelFromJson(jsonString);

import 'dart:convert';

OfficeListModel officeListModelFromJson(String str) => OfficeListModel.fromJson(json.decode(str));

String officeListModelToJson(OfficeListModel data) => json.encode(data.toJson());

class OfficeListModel {
  OfficeListModel({
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

  factory OfficeListModel.fromJson(Map<String, dynamic> json) => OfficeListModel(
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
