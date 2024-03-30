import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_event.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_state.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';

class TopicListBloc extends Bloc<TopicListEvent, TopicListState> {
  TopicListBloc() : super(TopicListInitialState()) {
    on<TopicListLoadingEvent>(_fetchTopics);
    on<TopicListLoadedEvent>((event, emit) {});

    on<TopicInsertedEvent>(_insertTopic);

    on<TopicListNotifyErrorEvent>((event, emit) {
      emit(TopicListErrorState());
    });
    on<TopicLoadingEvent>(_fetchTopic);
  }

  @override
  void onEvent(TopicListEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print(event);
    }
  }

  @override
  void onChange(Change<TopicListState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
    }
  }

  @override
  void onTransition(Transition<TopicListEvent, TopicListState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print(transition);
    }
  }

  void loadTopics() {
    add(TopicListLoadingEvent());
  }

  Future<void> _fetchTopics(
      TopicListEvent topicListEvent, Emitter<TopicListState> emit) async {
    emit(TopicListLoadingState());
    late PageResponse pageResponse;
    try {
      pageResponse = await ApiService.getPageTopic();
    } catch (e) {
      if (kDebugMode) {
        print('_fetchTopics error: $e');
      }
      handleError();
    }
    print('pageResponse: $pageResponse');
    List<TopicModel> listTopics =
        TopicModel.getTopicModelList(pageResponse.items);
    add(TopicListLoadedEvent());
    emit(TopicListLoadedState(topics: listTopics));
  }

  void _insertTopic(
      TopicInsertedEvent event, Emitter<TopicListState> emit) async {
    TopicModel topicModel = event.topicInfo;
    late TopicModel resTopic;
    try {
      resTopic = await ApiService.addTopic(topicModel);
    } catch (e) {
      handleError();
      return;
    }
    emit(TopicInsertedState(resTopic));
    loadTopics();
  }

  void handleError() {
    add(TopicListNotifyErrorEvent());
  }

  void _fetchTopic(
      TopicLoadingEvent event, Emitter<TopicListState> emit) async {
    late TopicModel topic;
    emit(TopicLoadingState());
    try {
      topic = await ApiService.getTopic(event.topicId);
    } catch (e) {
      if (kDebugMode) {
        print('_fetchTopic error: $e');
      }
      handleError();
    }

    emit(TopicLoadedState(topic: topic));
  }
}
