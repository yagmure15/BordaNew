// To parse this JSON data, do
//
//     final meetingRoomsModel = meetingRoomsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bordatech/utils/constants.dart';

MeetingRoomsModel meetingRoomsModelFromJson(String str) => MeetingRoomsModel.fromJson(json.decode(str));

String meetingRoomsModelToJson(MeetingRoomsModel data) => json.encode(data.toJson());

class MeetingRoomsModel {
  MeetingRoomsModel({
    required this.id,
    required this.capacity,
    required this.numberOfPeoplePresent,
    required this.roomType,
  });

  int id;
  int capacity;
  int numberOfPeoplePresent;
  int roomType;

  factory MeetingRoomsModel.fromJson(Map<String, dynamic> json) => MeetingRoomsModel(
    id: json["id"],
    capacity: json["capacity"],
    numberOfPeoplePresent: json["numberOfPeoplePresent"],
    roomType: json["roomType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "capacity": capacity,
    "numberOfPeoplePresent": numberOfPeoplePresent,
    "roomType": roomType,
  };
}
