// To parse this JSON data, do
//
//     final reportData = reportDataFromJson(jsonString);

import 'dart:convert';

ReportData reportDataFromJson(String str) => ReportData.fromJson(json.decode(str));

String reportDataToJson(ReportData data) => json.encode(data.toJson());

class ReportData {
    int code;
    bool status;
    String message;
    List<Datum> data;

    ReportData({
        this.code,
        this.status,
        this.message,
        this.data,
    });

    factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
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
    String id;
    String name;
    double long;
    double lat;
    String address;
    String localImage;
    int timestamp;
    String image;
    String description;
    String type;
    String networkstatus;

    Datum({
        this.id,
        this.name,
        this.long,
        this.lat,
        this.address,
        this.localImage,
        this.timestamp,
        this.image,
        this.description,
        this.type,
        this.networkstatus
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["NAME"],
        long: json["LONG"].toDouble(),
        lat: json["LAT"].toDouble(),
        address: json["ADDRESS"],
        localImage: json["LOCAL_IMAGE"],
        timestamp: json["TIMESTAMP"],
        image: json["IMAGE"],
        description: json["DESCRIPTION"],
        networkstatus:json["NETWORK_STATUS"],
        type: json["TYPE"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "NAME": name,
        "LONG": long,
        "LAT": lat,
        "ADDRESS": address,
        "LOCAL_IMAGE": localImage,
        "TIMESTAMP": timestamp,
        "IMAGE": image,
        "DESCRIPTION": description,
        "NETWORK_STATUS":networkstatus,
        "TYPE": type,
    };
}
