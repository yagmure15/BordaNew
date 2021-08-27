// To parse this JSON data, do
//
//     final meetingRoomModelByOfficeId = meetingRoomModelByOfficeIdFromJson(jsonString);

import 'dart:convert';

List<MeetingRoomModelByOfficeId> meetingRoomModelByOfficeIdFromJson(String str) => List<MeetingRoomModelByOfficeId>.from(json.decode(str).map((x) => MeetingRoomModelByOfficeId.fromJson(x)));

String meetingRoomModelByOfficeIdToJson(List<MeetingRoomModelByOfficeId> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeetingRoomModelByOfficeId {
  MeetingRoomModelByOfficeId({
    required this.id,
    required this.name,
    required this.capacity,
    required this.area,
    required this.numberOfPeoplePresent,
    required this.roomType,
  });

  int id;
  String name;
  int capacity;
  int area;
  int numberOfPeoplePresent;
  int roomType;

  factory MeetingRoomModelByOfficeId.fromJson(Map<String, dynamic> json) => MeetingRoomModelByOfficeId(
    id: json["id"],
    name: json["name"],
    capacity: json["capacity"],
    area: json["area"],
    numberOfPeoplePresent: json["numberOfPeoplePresent"],
    roomType: json["roomType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "capacity": capacity,
    "area": area,
    "numberOfPeoplePresent": numberOfPeoplePresent,
    "roomType": roomType,
  };
}
