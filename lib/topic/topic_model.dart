import 'package:quizlet_frontend/word/word_model.dart';

class TopicModel {
  String? id;
  String? name;
  int? wordCount;
  bool? public;
  String url;
  List<WordModel>? words;

  TopicModel(
      {this.id,
      this.name,
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

  bool isSameInformation(TopicModel newTopic) {
    return (name != newTopic.name ||
            public != newTopic.public ||
            url == newTopic.url)
        ? false
        : true;
  }

  int indexWord(String? wordId) {
    print('indexWord wordId: $wordId');

    if (words != null) {
      for (int i = 0; i < words!.length; i++) {
        print('words![i].id: ${words![i].id}');
        print('words![i].id == wordId: ${words![i].id == wordId}');
        if (words![i].id == wordId) {
          return i;
        }
      }
    }
    return -1;
  }

  void removeWordAt(int index) {
    if (words != null) words!.removeAt(index);
  }
}
