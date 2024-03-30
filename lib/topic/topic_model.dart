import 'package:quizlet_frontend/word/word_model.dart';

class TopicModel {
  String? id;
  String name;
  int? wordCount;
  bool? public;
  String url;
  List<WordModel>? words;

  TopicModel(
      {this.id,
      required this.name,
      this.wordCount,
      this.url = 'string',
      this.public,
      this.words});

  static List<TopicModel> getTopicModelList(List<dynamic> dynamicList) {
    List<TopicModel> topicModelList = [];
    for (Map<String, dynamic> i in dynamicList) {
      topicModelList.add(TopicModel.fromJson(i));
    }
    return topicModelList;
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
        id: json["id"],
        name: json["name"],
        wordCount: json["wordCount"],
        url: json["url"] ?? 'String',
        public: json["public"],
        words: json["words"] == null
            ? null
            : WordModel.getWordModelList(json["words"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "wordCount": wordCount,
        "public": public,
        "words": words,
      };
}
