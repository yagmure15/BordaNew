// To parse this JSON data, do
//
//     final notifyOfArrivalModel = notifyOfArrivalModelFromJson(jsonString);

import 'dart:convert';

List<NotifyOfArrivalModel> notifyOfArrivalModelFromJson(String str) => List<NotifyOfArrivalModel>.from(json.decode(str).map((x) => NotifyOfArrivalModel.fromJson(x)));

String notifyOfArrivalModelToJson(List<NotifyOfArrivalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotifyOfArrivalModel {
  NotifyOfArrivalModel({
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

  factory NotifyOfArrivalModel.fromJson(Map<String, dynamic> json) => NotifyOfArrivalModel(
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