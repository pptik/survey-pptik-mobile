// To parse this JSON data, do
//
//     final responseJurusan = responseJurusanFromJson(jsonString);

import 'dart:convert';

ResponseJurusan responseJurusanFromJson(String str) => ResponseJurusan.fromJson(json.decode(str));

String responseJurusanToJson(ResponseJurusan data) => json.encode(data.toJson());

class ResponseJurusan {
  ResponseJurusan({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int code;
  bool status;
  String message;
  List<Datum> data;

  factory ResponseJurusan.fromJson(Map<String, dynamic> json) => ResponseJurusan(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.companyName,
    this.companyCode,
  });

  String companyName;
  String companyCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    companyName: json["COMPANY_NAME"],
    companyCode: json["COMPANY_CODE"],
  );

  Map<String, dynamic> toJson() => {
    "COMPANY_NAME": companyName,
    "COMPANY_CODE": companyCode,
  };
}
