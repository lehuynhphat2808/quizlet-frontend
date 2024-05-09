import 'package:quizlet_frontend/user/user_model.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class TopicModel {
  String? id;
  String? name;
  int? wordCount;
  bool? public;
  String url;
  UserModel? owner;
  List<WordModel>? words;

  TopicModel(
      {this.id,
      this.name,
      this.wordCount,
      this.url = 'string',
      this.public,
      this.words,
      this.owner});

  static List<TopicModel> getTopicModelList(List<dynamic> dynamicList) {
    print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    print('dynamicList: $dynamicList');
    List<TopicModel> topicModelList = [];
    for (Map<String, dynamic> i in dynamicList) {
      topicModelList.add(TopicModel.fromJson(i));
    }
    print('topicModelList: $topicModelList');
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
        owner: json['owner'] == null ? null : UserModel.fromJson(json['owner']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "wordCount": wordCount,
        "public": public,
        "words": words,
        "owner": owner,
      };

  bool isSameInformation(TopicModel newTopic) {
    return (name != newTopic.name ||
            public != newTopic.public ||
            url != newTopic.url)
        ? false
        : true;
  }

  TopicModel copyWith({
    String? id,
    String? name,
    int? wordCount,
    String? url,
    bool? public,
    List<WordModel>? words,
    UserModel? owner,
  }) {
    return TopicModel(
        id: id ?? this.id,
        name: name ?? this.name,
        wordCount: wordCount ?? this.wordCount,
        url: url ?? this.url,
        public: public ?? this.public,
        words: words ?? this.words,
        owner: owner ?? this.owner);
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
