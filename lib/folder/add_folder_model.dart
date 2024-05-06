// To parse this JSON data, do
//
//     final addFolderModel = addFolderModelFromJson(jsonString);

import 'dart:convert';

AddFolderModel addFolderModelFromJson(String str) =>
    AddFolderModel.fromJson(json.decode(str));

String addFolderModelToJson(AddFolderModel data) => json.encode(data.toJson());

class AddFolderModel {
  String? name;
  List<String> topicIds;

  AddFolderModel({
    this.name,
    topicIds,
  }) : topicIds = topicIds ?? [];

  factory AddFolderModel.fromJson(Map<String, dynamic> json) => AddFolderModel(
        name: json["name"],
        topicIds: List<String>.from(json["topicIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "topicIds": List<dynamic>.from(topicIds.map((x) => x)),
      };
}
