class TopicModel {
  String id;
  String name;
  bool public;

  static List<TopicModel> topicModelList = [];

  TopicModel({
    required this.id,
    required this.name,
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
        public: json["public"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "public": public,
      };
}
