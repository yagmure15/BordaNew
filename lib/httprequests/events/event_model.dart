// To parse this JSON data, do
//
//     final eventOrganizationModel = eventOrganizationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';



import 'dart:convert';

List<EventOrganizationModel> eventOrganizationModelFromJson(String str) => List<EventOrganizationModel>.from(json.decode(str).map((x) => EventOrganizationModel.fromJson(x)));

String eventOrganizationModelToJson(List<EventOrganizationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventOrganizationModel {
  EventOrganizationModel({
    required this.id,
    required this.attendees,
    required this.organizer,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    required this.isCancelled,
    required this.description,
  });

  int id;
  List<dynamic> attendees;
  String organizer;
  int eventType;
  DateTime startDate;
  DateTime endDate;
  bool isCancelled;
  String description;

  factory EventOrganizationModel.fromJson(Map<String, dynamic> json) => EventOrganizationModel(
    id: json["id"],
    attendees: List<dynamic>.from(json["attendees"].map((x) => x)),
    organizer: json["organizer"],
    eventType: json["eventType"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    isCancelled: json["isCancelled"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendees": List<dynamic>.from(attendees.map((x) => x)),
    "organizer": organizer,
    "eventType": eventType,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "isCancelled": isCancelled,
    "description": description,
  };
}









