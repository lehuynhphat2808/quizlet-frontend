// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  String status;
  String timestamp;
  String message;
  dynamic debugMessage;
  List<dynamic> errors;

  ErrorResponse({
    required this.status,
    required this.timestamp,
    required this.message,
    required this.debugMessage,
    required this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"],
        timestamp: json["timestamp"],
        message: json["message"],
        debugMessage: json["debugMessage"],
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "timestamp": timestamp,
        "message": message,
        "debugMessage": debugMessage,
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}
