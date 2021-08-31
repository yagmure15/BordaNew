// To parse this JSON data, do
//
//     final myCalendarModel = myCalendarModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyCalendarModel myCalendarModelFromJson(String str) => MyCalendarModel.fromJson(json.decode(str));

String myCalendarModelToJson(MyCalendarModel data) => json.encode(data.toJson());

class MyCalendarModel {
  MyCalendarModel({
    required this.notificationOfArrivals,
    required this.hotDeskReservations,
    required this.meetingRoomReservations,
  });

  List<NotificationOfArrival> notificationOfArrivals;
  List<HotDeskReservation> hotDeskReservations;
  List<MeetingRoomReservation> meetingRoomReservations;

  factory MyCalendarModel.fromJson(Map<String, dynamic> json) => MyCalendarModel(
    notificationOfArrivals: List<NotificationOfArrival>.from(json["notificationOfArrivals"].map((x) => NotificationOfArrival.fromJson(x))),
    hotDeskReservations: List<HotDeskReservation>.from(json["hotDeskReservations"].map((x) => HotDeskReservation.fromJson(x))),
    meetingRoomReservations: List<MeetingRoomReservation>.from(json["meetingRoomReservations"].map((x) => MeetingRoomReservation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notificationOfArrivals": List<dynamic>.from(notificationOfArrivals.map((x) => x.toJson())),
    "hotDeskReservations": List<dynamic>.from(hotDeskReservations.map((x) => x.toJson())),
    "meetingRoomReservations": List<dynamic>.from(meetingRoomReservations.map((x) => x.toJson())),
  };
}

class HotDeskReservation {
  HotDeskReservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.applicationUserId,
    required this.hotDeskId,
    required this.isCancelled,
  });

  int id;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  String applicationUserId;
  int hotDeskId;
  bool isCancelled;

  factory HotDeskReservation.fromJson(Map<String, dynamic> json) => HotDeskReservation(
    id: json["id"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    applicationUserId: json["applicationUserId"],
    hotDeskId: json["hotDeskId"],
    isCancelled: json["isCancelled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "applicationUserId": applicationUserId,
    "hotDeskId": hotDeskId,
    "isCancelled": isCancelled,
  };
}

class MeetingRoomReservation {
  MeetingRoomReservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isCancelled,
    required this.organizerId,
    required this.attendees,
    required this.meetingRoomId,
  });

  int id;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  bool isCancelled;
  String organizerId;
  List<String> attendees;
  int meetingRoomId;

  factory MeetingRoomReservation.fromJson(Map<String, dynamic> json) => MeetingRoomReservation(
    id: json["id"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isCancelled: json["isCancelled"],
    organizerId: json["organizerId"],
    attendees: List<String>.from(json["attendees"].map((x) => x)),
    meetingRoomId: json["meetingRoomId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "isCancelled": isCancelled,
    "organizerId": organizerId,
    "attendees": List<dynamic>.from(attendees.map((x) => x)),
    "meetingRoomId": meetingRoomId,
  };
}

class NotificationOfArrival {
  NotificationOfArrival({
    required this.id,
    required this.officeId,
    required this.userId,
    required this.numberOfGuests,
    required this.petPresence,
    required this.dateOfArrival,
    required this.createdAt,
    required this.isCancelled,
  });

  int id;
  int officeId;
  String userId;
  int numberOfGuests;
  bool petPresence;
  DateTime dateOfArrival;
  DateTime createdAt;
  bool isCancelled;

  factory NotificationOfArrival.fromJson(Map<String, dynamic> json) => NotificationOfArrival(
    id: json["id"],
    officeId: json["officeId"],
    userId: json["userId"],
    numberOfGuests: json["numberOfGuests"],
    petPresence: json["petPresence"],
    dateOfArrival: DateTime.parse(json["dateOfArrival"]),
    createdAt: DateTime.parse(json["createdAt"]),
    isCancelled: json["isCancelled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "officeId": officeId,
    "userId": userId,
    "numberOfGuests": numberOfGuests,
    "petPresence": petPresence,
    "dateOfArrival": dateOfArrival.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "isCancelled": isCancelled,
  };
}
