// To parse this JSON data, do
//
//     final absentData = absentDataFromJson(jsonString);

import 'dart:convert';

AbsentData absentDataFromJson(String str) =>
    AbsentData.fromJson(json.decode(str));

String absentDataToJson(AbsentData data) => json.encode(data.toJson());

class AbsentData {
  String status;
  Data data;

  AbsentData({
    this.status,
    this.data,
  });

  factory AbsentData.fromJson(Map<String, dynamic> json) => AbsentData(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String name;
  String company;
  String guid;

  Data({
    this.name,
    this.company,
    this.guid,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["NAME"],
        company: json["COMPANY"],
        guid: json["GUID"],
      );

  Map<String, dynamic> toJson() => {
        "NAME": name,
        "COMPANY": company,
        "GUID": guid,
      };
}
