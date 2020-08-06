// To parse this JSON data, do
//
//     final responseAreas = responseAreasFromJson(jsonString);

import 'dart:convert';

ResponseAreas responseAreasFromJson(String str) => ResponseAreas.fromJson(json.decode(str));

String responseAreasToJson(ResponseAreas data) => json.encode(data.toJson());

class ResponseAreas {
  ResponseAreas({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int code;
  bool status;
  String message;
  Data data;

  factory ResponseAreas.fromJson(Map<String, dynamic> json) => ResponseAreas(
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
  Data({
    this.areas,
  });

  List<Area> areas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
  };
}

class Area {
  Area({
    this.area,
    this.districts,
  });

  String area;
  List<String> districts;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    area: json["AREA"],
    districts: List<String>.from(json["DISTRICTS"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "AREA": area,
    "DISTRICTS": List<dynamic>.from(districts.map((x) => x)),
  };
}
