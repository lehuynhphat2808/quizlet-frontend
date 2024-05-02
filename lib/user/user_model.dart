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
  int score;
  int rank;

  UserModel({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.score,
    required this.rank,
  });

  UserModel copyWith({
    String? id,
    String? nickname,
    String? avatar,
    int? score,
    int? rank,
  }) =>
      UserModel(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        avatar: avatar ?? this.avatar,
        score: score ?? this.score,
        rank: rank ?? this.rank,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        score: json["score"],
        rank: json["rank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "avatar": avatar,
        "score": score,
        "rank": rank,
      };
}
