// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  int code;
  bool status;
  String message;
  Data data;

  LoginData({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String phoneNumber;
  String name;
  String email;
  String company;
  String unit;
  String position;
  String localImage;
  String guid;
  String image;

  Data({
    this.phoneNumber,
    this.name,
    this.email,
    this.company,
    this.unit,
    this.position,
    this.localImage,
    this.guid,
    this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        phoneNumber: json["PHONE_NUMBER"],
        name: json["NAME"],
        email: json["EMAIL"],
        company: json["COMPANY"],
        unit: json["UNIT"],
        position: json["POSITION"],
        localImage: json["LOCAL_IMAGE"],
        guid: json["GUID"],
        image: json["IMAGE"],
      );

  Map<String, dynamic> toJson() => {
        "PHONE_NUMBER": phoneNumber,
        "NAME": name,
        "EMAIL": email,
        "COMPANY": company,
        "UNIT": unit,
        "POSITION": position,
        "LOCAL_IMAGE": localImage,
        "GUID": guid,
        "IMAGE": image,
      };
}
