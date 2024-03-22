import 'package:quizlet_frontend/topic/TopicModel.dart';

abstract class TopicListEvent {}

class TopicListLoading extends TopicListEvent {
  @override
  String toString() {
    // TODO: implement toString
    return "Topic is loading";
  }
}

class TopicListInserted extends TopicListEvent {
  final TopicModel topicInfo;

  TopicListInserted({required this.topicInfo});

  @override
  String toString() {
    return "Event TopicListInserted: $topicInfo";
  }
}

class TopicListRemoved extends TopicListEvent {
  final int id;

  TopicListRemoved({required this.id});

  @override
  String toString() {
    return "Event TopicListRemoved: $id";
  }
}

class TopicListEdited extends TopicListEvent {
  final TopicModel topicInfo;

  TopicListEdited({required this.topicInfo});

  @override
  String toString() {
    return "Event TopicListEdited: $topicInfo";
  }
}

class TopicListLoaded extends TopicListEvent {
  final List<TopicModel> topics;

  TopicListLoaded({required this.topics});

  @override
  String toString() {
    return "Event TopicListLoaded: ${topics.map((e) => e.toString())}";
  }
}

class TopicListNotifyError extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicListNotifyError";
  }
}

class TopicListErrorConfirmed extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicListErrorConfirmed";
  }
}
