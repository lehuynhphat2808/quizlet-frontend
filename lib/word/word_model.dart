import 'dart:convert';

WordModel wordModelFromJson(String str) => WordModel.fromJson(json.decode(str));

String wordModelToJson(WordModel data) => json.encode(data.toJson());

class WordModel {
  String? id;
  String? name;
  String? definition;
  bool? isMarked;
  dynamic status;
  String? topicId;

  WordModel({
    this.id,
    this.name,
    this.definition,
    this.isMarked,
    this.status,
    this.topicId,
  });

  WordModel copyWith({
    String? id,
    String? name,
    String? definition,
    bool? isMarked,
    dynamic status,
    String? topicId,
  }) =>
      WordModel(
        id: id ?? this.id,
        name: name ?? this.name,
        definition: definition ?? this.definition,
        isMarked: isMarked ?? this.isMarked,
        status: status ?? this.status,
        topicId: topicId ?? this.topicId,
      );

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        id: json["id"],
        name: json["name"],
        definition: json["definition"],
        isMarked: json["isMarked"],
        status: json["status"],
        topicId: json["topicId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "definition": definition,
        "isMarked": isMarked,
        "status": status,
        "topicId": topicId,
      };
}
