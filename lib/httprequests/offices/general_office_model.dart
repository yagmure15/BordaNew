// To parse this JSON data, do
//
//     final generalOfficeModel = generalOfficeModelFromJson(jsonString);

import 'dart:convert';

List<GeneralOfficeModel> generalOfficeModelFromJson(String str) => List<GeneralOfficeModel>.from(json.decode(str).map((x) => GeneralOfficeModel.fromJson(x)));

String generalOfficeModelToJson(List<GeneralOfficeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeneralOfficeModel {
  GeneralOfficeModel({
    required this.id,
    required this.capacity,
    required this.numberOfPeoplePresent,
    required this.temperature,
    required this.humidity,
  });

  int id;
  int capacity;
  int numberOfPeoplePresent;
  int temperature;
  int humidity;

  factory GeneralOfficeModel.fromJson(Map<String, dynamic> json) => GeneralOfficeModel(
    id: json["id"],
    capacity: json["capacity"],
    numberOfPeoplePresent: json["numberOfPeoplePresent"],
    temperature: json["temperature"],
    humidity: json["humidity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "capacity": capacity,
    "numberOfPeoplePresent": numberOfPeoplePresent,
    "temperature": temperature,
    "humidity": humidity,
  };
}
