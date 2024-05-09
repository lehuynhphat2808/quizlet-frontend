import 'dart:convert';

WordModel wordModelFromJson(String str) => WordModel.fromJson(json.decode(str));

String wordModelToJson(WordModel data) => json.encode(data.toJson());

class WordModel {
  String? id;
  String? name;
  String? definition;
  bool? marked;
  dynamic status;
  String? topicId;
  int? learningCount;

  WordModel({
    this.id,
    this.name,
    this.definition,
    this.marked,
    this.status,
    this.topicId,
    this.learningCount,
  });

  static late List<WordModel> wordModelList;

  static List<WordModel> getWordModelList(List<dynamic> dynamicList) {
    wordModelList = [];
    for (Map<String, dynamic> i in dynamicList) {
      wordModelList.add(WordModel.fromJson(i));
    }
    return wordModelList;
  }

  WordModel copyWith({
    String? id,
    String? name,
    String? definition,
    bool? marked,
    dynamic status,
    String? topicId,
    int? learningCount,
  }) =>
      WordModel(
          id: id ?? this.id,
          name: name ?? this.name,
          definition: definition ?? this.definition,
          marked: marked ?? this.marked,
          status: status ?? this.status,
          topicId: topicId ?? this.topicId,
          learningCount: learningCount ?? this.learningCount);

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        id: json["id"],
        name: json["name"],
        definition: json["definition"],
        marked: json["marked"],
        status: json["status"],
        topicId: json["topicId"],
        learningCount: json["learningCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "definition": definition,
        "marked": marked,
        "status": status,
        "topicId": topicId,
        "learningCount": learningCount,
      };
}
