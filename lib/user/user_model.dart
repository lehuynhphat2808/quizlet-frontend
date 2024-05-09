// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String nickname;
  String avatar;
  String? email;
  int? score;
  int? rank;
  String? languageCode;

  UserModel({
    required this.id,
    required this.nickname,
    required this.avatar,
    this.score,
    this.rank,
    this.email,
    this.languageCode,
  });

  UserModel copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? email,
    int? score,
    int? rank,
    String? languageCode,
  }) =>
      UserModel(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        avatar: avatar ?? this.avatar,
        score: score ?? this.score,
        rank: rank ?? this.rank,
        email: email ?? this.email,
        languageCode: languageCode ?? this.languageCode,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        score: json["score"],
        rank: json["rank"],
        email: json["email"],
        languageCode: json["languageCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "avatar": avatar,
        "score": score,
        "rank": rank,
        "email": email,
        "languageCode": languageCode,
      };
}
