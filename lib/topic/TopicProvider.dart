import 'package:flutter/foundation.dart';
import 'package:quizlet_frontend/utilities/PageResponse.dart';
import 'package:quizlet_frontend/services/ApiService.dart';

import 'TopicModel.dart';

class TopicProvider extends ChangeNotifier {
  final List<TopicModel> _topicModels = [];

  Future<void> getTopics() async {
    PageResponse pageResponse = await ApiService.getPageTopic();
    for (Map<String, dynamic> i in pageResponse.items) {
      _topicModels.add(TopicModel.fromJson(i));
    }
    notifyListeners();
  }

  List<TopicModel> get topicModels => _topicModels;
}
