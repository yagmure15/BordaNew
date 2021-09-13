// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    required this.fullName,
    required this.birthday,
    required this.email,
    required this.officeId,
    required this.departmentId,
    required this.beaconMacAddress,
  });

  String fullName;
  DateTime birthday;
  String email;
  int officeId;
  int departmentId;
  String beaconMacAddress;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        fullName: json["fullName"],
        birthday: DateTime.parse(json["birthday"]),
        email: json["email"],
        officeId: json["officeId"],
        departmentId: json["departmentId"],
        beaconMacAddress: json["beaconMacAddress"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "birthday": birthday.toIso8601String(),
        "email": email,
        "officeId": officeId,
        "departmentId": departmentId,
        "beaconMacAddress": beaconMacAddress,
      };
}
