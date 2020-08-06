// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));
String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String status;
  Data data;
  String message;

  UserData({
    this.status,
    this.data,
    this.message
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"]
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message":message
      };
}

class Data {
  String phoneNumber;
  String id;
  String name;
  String email;
  String company;
  String unit;
  String position;
  String idCard;
  int timestamp;
  String localImage;
  String guid;
  String image;

  Data({
    this.phoneNumber,
    this.id,
    this.name,
    this.email,
    this.company,
    this.unit,
    this.position,
    this.idCard,
    this.timestamp,
    this.localImage,
    this.guid,
    this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        phoneNumber: json["PHONE_NUMBER"],
        id: json["_id"],
        name: json["NAME"],
        email: json["EMAIL"],
        company: json["COMPANY"],
        unit: json["UNIT"],
        position: json["POSITION"],
        idCard: json["PASSWORD"],
        timestamp: json["TIMESTAMP"],
        localImage: json["LOCAL_IMAGE"],
        guid: json["GUID"],
        image: json["IMAGE"],
      );

  Map<String, dynamic> toJson() => {
        "PHONE_NUMBER": phoneNumber,
        "_id": id,
        "NAME": name,
        "EMAIL": email,
        "COMPANY": company,
        "UNIT": unit,
        "POSITION": position,
        "ID_CARD": idCard,
        "TIMESTAMP": timestamp,
        "LOCAL_IMAGE": localImage,
        "GUID": guid,
        "IMAGE": image,
      };
}
