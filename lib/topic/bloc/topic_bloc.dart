import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/bloc/topic_event.dart';
import 'package:quizlet_frontend/topic/bloc/topic_state.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';

class TopicListBloc extends Bloc<TopicListEvent, TopicListState> {
  TopicListBloc() : super(TopicListInitialState()) {
    on<TopicListLoadingEvent>(_fetchTopics);
    on<TopicListLoadedEvent>((event, emit) {});

    on<TopicInsertedEvent>(_insertTopic);

    on<TopicListNotifyErrorEvent>((event, emit) {
      emit(TopicListErrorState());
    });
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

  void _loadTopics() {
    add(TopicListLoadingEvent());
  }

  Future<void> _fetchTopics(
      TopicListEvent topicListEvent, Emitter<TopicListState> emit) async {
    final List<TopicModel> listTopics = [];
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
    for (Map<String, dynamic> i in pageResponse.items) {
      listTopics.add(TopicModel.fromJson(i));
    }

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
    print('ooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    emit(TopicInsertedState(resTopic));
  }

  void handleError() {
    add(TopicListNotifyErrorEvent());
  }
}
