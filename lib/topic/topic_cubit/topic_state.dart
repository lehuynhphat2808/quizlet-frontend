import 'package:quizlet_frontend/topic/topic_model.dart';

abstract class TopicState {}

class TopicInitialState extends TopicState {}

class TopicLoadingState extends TopicState {}

class TopicLoadedState extends TopicState {
  final TopicModel topic;

  TopicLoadedState({required this.topic});
}

class TopicDeletingState extends TopicState {}

class TopicErrorState extends TopicState {}
