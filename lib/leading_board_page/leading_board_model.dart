// To parse this JSON data, do
//
//     final leadingBoardModel = leadingBoardModelFromJson(jsonString);

import 'dart:convert';

LeadingBoardModel leadingBoardModelFromJson(String str) =>
    LeadingBoardModel.fromJson(json.decode(str));

String leadingBoardModelToJson(LeadingBoardModel data) =>
    json.encode(data.toJson());

class LeadingBoardModel {
  List<User> users;
  String topicId;
  int lastModifyTimestampMs;

  LeadingBoardModel({
    required this.users,
    required this.topicId,
    required this.lastModifyTimestampMs,
  });

  LeadingBoardModel copyWith({
    List<User>? users,
    String? topicId,
    int? lastModifyTimestampMs,
  }) =>
      LeadingBoardModel(
        users: users ?? this.users,
        topicId: topicId ?? this.topicId,
        lastModifyTimestampMs:
            lastModifyTimestampMs ?? this.lastModifyTimestampMs,
      );

  factory LeadingBoardModel.fromJson(Map<String, dynamic> json) =>
      LeadingBoardModel(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        topicId: json["topicId"],
        lastModifyTimestampMs: json["lastModifyTimestampMs"],
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "topicId": topicId,
        "lastModifyTimestampMs": lastModifyTimestampMs,
      };
}

class User {
  String id;
  String nickname;
  String avatar;
  double score;
  int rank;

  User({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.score,
    required this.rank,
  });

  User copyWith({
    String? id,
    String? nickname,
    String? avatar,
    double? score,
    int? rank,
  }) =>
      User(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        avatar: avatar ?? this.avatar,
        score: score ?? this.score,
        rank: rank ?? this.rank,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
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
