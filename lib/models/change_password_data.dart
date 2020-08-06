
// To parse this JSON data, do
//
//     final changePasswordData = changePasswordDataFromJson(jsonString);

import 'dart:convert';

ChangePasswordData changePasswordDataFromJson(String str) => ChangePasswordData.fromJson(json.decode(str));

String changePasswordDataToJson(ChangePasswordData data) => json.encode(data.toJson());

class ChangePasswordData {
    int code;
    bool status;
    String message;

    ChangePasswordData({
        this.code,
        this.status,
        this.message,
    });

    factory ChangePasswordData.fromJson(Map<String, dynamic> json) => ChangePasswordData(
        code: json["code"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
    };
}
