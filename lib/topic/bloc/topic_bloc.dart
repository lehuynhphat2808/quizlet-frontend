import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/topic/TopicModel.dart';
import 'package:quizlet_frontend/services/ApiService.dart';
import 'package:quizlet_frontend/topic/bloc/topic_event.dart';
import 'package:quizlet_frontend/topic/bloc/topic_state.dart';
import 'package:quizlet_frontend/utilities/PageResponse.dart';

class TopicListBloc extends Bloc<TopicListEvent, TopicListState> {
  TopicListBloc() : super(const TopicListState(isLoading: true)) {
    on<TopicListLoading>((event, emit) {
      final newState = state.copyWith(isLoading: false);
      emit(newState);
      _getTopics();
    });
    on<TopicListLoaded>((event, emit) {
      emit(state.copyWith(
          topics: event.topics, isLoading: false, isError: false));
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
    add(TopicListLoading());
  }

  void _getTopics() async {
    final List<TopicModel> listTopics = [];
    PageResponse pageResponse = await ApiService.getPageTopic();
    for (Map<String, dynamic> i in pageResponse.items) {
      listTopics.add(TopicModel.fromJson(i));
    }
    add(TopicListLoaded(topics: listTopics));
  }
}
