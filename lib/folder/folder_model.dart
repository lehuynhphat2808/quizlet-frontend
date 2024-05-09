// To parse this JSON data, do
//
//     final folderModel = folderModelFromJson(jsonString);

import 'dart:convert';

import 'package:quizlet_frontend/topic/topic_model.dart';

FolderModel folderModelFromJson(String str) =>
    FolderModel.fromJson(json.decode(str));

String folderModelToJson(FolderModel data) => json.encode(data.toJson());

class FolderModel {
  String id;
  String name;
  List<TopicModel>? topics;
  int? topicCount;

  FolderModel({
    required this.id,
    required this.name,
    this.topics,
    this.topicCount,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
        id: json["id"],
        name: json["name"],
        topics: json["topics"] == null
            ? []
            : TopicModel.getTopicModelList(json["topics"]),
        topicCount: json['topicCount'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "topics": List<dynamic>.from(topics!.map((x) => x.toJson())),
        "topicCount": topicCount,
      };
  static List<FolderModel> getFolderModelList(List<dynamic> dynamicList) {
    List<FolderModel> folderModelList = [];
    for (Map<String, dynamic> i in dynamicList) {
      folderModelList.add(FolderModel.fromJson(i));
    }
    return folderModelList;
  }
}
