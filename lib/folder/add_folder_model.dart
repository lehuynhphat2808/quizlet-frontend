// To parse this JSON data, do
//
//     final addTopicModel = addTopicModelFromJson(jsonString);

import 'dart:convert';

AddTopicModel addTopicModelFromJson(String str) =>
    AddTopicModel.fromJson(json.decode(str));

String addTopicModelToJson(AddTopicModel data) => json.encode(data.toJson());

class AddTopicModel {
  String name;
  List<String> topicIds;

  AddTopicModel({
    required this.name,
    required this.topicIds,
  });

  factory AddTopicModel.fromJson(Map<String, dynamic> json) => AddTopicModel(
        name: json["name"],
        topicIds: List<String>.from(json["topicIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "topicIds": List<dynamic>.from(topicIds.map((x) => x)),
      };
}
