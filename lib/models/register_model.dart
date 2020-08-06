// To parse this JSON data, do
//
//     final responseRegister = responseRegisterFromJson(jsonString);

import 'dart:convert';

ResponseRegister responseRegisterFromJson(String str) => ResponseRegister.fromJson(json.decode(str));

String responseRegisterToJson(ResponseRegister data) => json.encode(data.toJson());

class ResponseRegister {
    int code;
    bool status;
    String message;

    ResponseRegister({
        this.code,
        this.status,
        this.message,
    });

    factory ResponseRegister.fromJson(Map<String, dynamic> json) => ResponseRegister(
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
