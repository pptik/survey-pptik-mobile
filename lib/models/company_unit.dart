// To parse this JSON data, do
//
//     final companyUnitData = companyUnitDataFromJson(jsonString);

import 'dart:convert';

CompanyUnitData companyUnitDataFromJson(String str) =>
    CompanyUnitData.fromJson(json.decode(str));

String companyUnitDataToJson(CompanyUnitData data) =>
    json.encode(data.toJson());

class CompanyUnitData {
  int code;
  bool status;
  String message;
  List<String> data;

  CompanyUnitData({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory CompanyUnitData.fromJson(Map<String, dynamic> json) =>
      CompanyUnitData(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
