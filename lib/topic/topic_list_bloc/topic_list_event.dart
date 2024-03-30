import 'package:quizlet_frontend/topic/topic_model.dart';

abstract class TopicListEvent {}

class TopicListLoadingEvent extends TopicListEvent {
  @override
  String toString() {
    return "Topic is loading";
  }
}

class TopicLoadingEvent extends TopicListEvent {
  final String topicId;

  TopicLoadingEvent(this.topicId);
  @override
  String toString() {
    return "Topic is loading";
  }
}

class TopicInsertedEvent extends TopicListEvent {
  final TopicModel topicInfo;

  TopicInsertedEvent({required this.topicInfo});

  @override
  String toString() {
    return "Event TopicListInserted: $topicInfo";
  }
}

class TopicListRemovedEvent extends TopicListEvent {
  final int id;

  TopicListRemovedEvent({required this.id});

  @override
  String toString() {
    return "Event TopicListRemoved: $id";
  }
}

class TopicListEditedEvent extends TopicListEvent {
  final TopicModel topicInfo;

  TopicListEditedEvent({required this.topicInfo});

  @override
  String toString() {
    return "Event TopicListEdited: $topicInfo";
  }
}

class TopicListLoadedEvent extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicListLoaded:";
  }
}

class TopicLoadedEvent extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicLoaded:";
  }
}

class TopicListNotifyErrorEvent extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicListNotifyError";
  }
}

class TopicListErrorConfirmedEvent extends TopicListEvent {
  @override
  String toString() {
    return "Event TopicListErrorConfirmed";
  }
}

class TodoListNotifyErrorEvent extends TopicListEvent {
  @override
  String toString() {
    return "Event TodoListNotifyError";
  }
}
