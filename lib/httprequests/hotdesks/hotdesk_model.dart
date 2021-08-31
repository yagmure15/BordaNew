// To parse this JSON data, do
//
//     final hotdeskModel = hotdeskModelFromJson(jsonString);

import 'dart:convert';

List<HotdeskModel> hotdeskModelFromJson(String str) => List<HotdeskModel>.from(json.decode(str).map((x) => HotdeskModel.fromJson(x)));

String hotdeskModelToJson(List<HotdeskModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HotdeskModel {
  HotdeskModel({
    required this.id,
    required this.name,
    required this.hotDeskReservations,
  });

  int id;
  String name;
  List<HotDeskReservation> hotDeskReservations;

  factory HotdeskModel.fromJson(Map<String, dynamic> json) => HotdeskModel(
    id: json["id"],
    name: json["name"],
    hotDeskReservations: List<HotDeskReservation>.from(json["hotDeskReservations"].map((x) => HotDeskReservation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hotDeskReservations": List<dynamic>.from(hotDeskReservations.map((x) => x.toJson())),
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
    required this.applicationUser,
  });

  int id;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  String applicationUserId;
  ApplicationUser applicationUser;

  factory HotDeskReservation.fromJson(Map<String, dynamic> json) => HotDeskReservation(
    id: json["id"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    applicationUserId: json["applicationUserId"],
    applicationUser: ApplicationUser.fromJson(json["applicationUser"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "applicationUserId": applicationUserId,
    "applicationUser": applicationUser.toJson(),
  };
}

class ApplicationUser {
  ApplicationUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.birthday,
    required this.officeId,
    required this.departmentId,
  });

  String id;
  String fullName;
  String email;
  DateTime birthday;
  int officeId;
  int departmentId;

  factory ApplicationUser.fromJson(Map<String, dynamic> json) => ApplicationUser(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    birthday: DateTime.parse(json["birthday"]),
    officeId: json["officeId"],
    departmentId: json["departmentId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "birthday": birthday.toIso8601String(),
    "officeId": officeId,
    "departmentId": departmentId,
  };
}
