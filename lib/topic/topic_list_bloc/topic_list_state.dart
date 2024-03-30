import 'package:quizlet_frontend/topic/topic_model.dart';

abstract class TopicListState {}

class TopicListInitialState extends TopicListState {}

class TopicListLoadingState extends TopicListState {}

class TopicLoadingState extends TopicListState {}

class TopicLoadedState extends TopicListState {
  final TopicModel topic;

  TopicLoadedState({required this.topic});
}

class TopicInsertedState extends TopicListState {
  final TopicModel topicModel;

  TopicInsertedState(this.topicModel);
}

class TopicListLoadedState extends TopicListState {
  final List<TopicModel> topics;

  TopicListLoadedState({this.topics = const []});

  @override
  String toString() {
    return "TopicListLoadedState(topics: ${topics.map((e) => e.toString())},)";
  }
}

class TopicListErrorState extends TopicListState {}
