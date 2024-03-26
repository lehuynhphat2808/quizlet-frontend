class TopicModel {
  String? id;
  String name;
  int? wordCount;
  bool public;
  String url;

  static List<TopicModel> topicModelList = [];

  TopicModel({
    this.id,
    required this.name,
    this.wordCount,
    this.url = 'string',
    required this.public,
  });

  static List<TopicModel> getTopicModelList(List<dynamic> dynamicList) {
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "wordCount": wordCount,
        "public": public,
      };
}
