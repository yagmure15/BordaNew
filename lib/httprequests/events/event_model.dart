// To parse this JSON data, do
//
//     final eventOrganizationModel = eventOrganizationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EventOrganizationModel eventOrganizationModelFromJson(String str) => EventOrganizationModel.fromJson(json.decode(str));

String eventOrganizationModelToJson(EventOrganizationModel data) => json.encode(data.toJson());

class EventOrganizationModel {
  EventOrganizationModel({
    required this.id,
    required this.attendees,
    required this.organizer,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    required this.isCancelled,
  });

  int id;
  List<dynamic> attendees;
  String organizer;
  int eventType;
  DateTime startDate;
  DateTime endDate;
  bool isCancelled;

  factory EventOrganizationModel.fromJson(Map<String, dynamic> json) => EventOrganizationModel(
    id: json["id"],
    attendees: List<dynamic>.from(json["attendees"].map((x) => x)),
    organizer: json["organizer"],
    eventType: json["eventType"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    isCancelled: json["isCancelled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendees": List<dynamic>.from(attendees.map((x) => x)),
    "organizer": organizer,
    "eventType": eventType,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "isCancelled": isCancelled,
  };
}
