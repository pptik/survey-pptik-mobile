// To parse this JSON data, do
//
//     final updateCompanyData = updateCompanyDataFromJson(jsonString);

import 'dart:convert';

UpdateCompanyData updateCompanyDataFromJson(String str) =>
    UpdateCompanyData.fromJson(json.decode(str));

String updateCompanyDataToJson(UpdateCompanyData data) =>
    json.encode(data.toJson());

class UpdateCompanyData {
  int code;
  bool status;
  String message;
  Data data;

  UpdateCompanyData({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory UpdateCompanyData.fromJson(Map<String, dynamic> json) =>
      UpdateCompanyData(
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
  String unit;
  String company;

  Data({
    this.unit,
    this.company,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        unit: json["UNIT"],
        company: json["COMPANY"],
      );

  Map<String, dynamic> toJson() => {
        "UNIT": unit,
        "COMPANY": company,
      };
}
