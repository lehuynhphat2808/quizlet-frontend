import 'package:quizlet_frontend/topic/topic_model.dart';

abstract class WordState {}

class WordInitialState extends WordState {}

class WordLoadingState extends WordState {}

class WordLoadedState extends WordState {
  final List<TopicModel> topics;

  WordLoadedState({this.topics = const []});

  @override
  String toString() {
    return "WordLoadedState(topics: ${topics.map((e) => e.toString())},)";
  }
}

class WordErrorState extends WordState {}
