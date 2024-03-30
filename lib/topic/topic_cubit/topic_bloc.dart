import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_state.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_bloc.dart';

import '../topic_model.dart';

class TopicCubit extends Cubit<TopicState> {
  TopicListBloc topicListBloc;
  TopicCubit({required this.topicListBloc}) : super(TopicInitialState());

  void init() {
    emit(TopicInitialState());
  }

  void getTopic(String id) async {
    emit(TopicLoadingState());
    TopicModel topicModel = await ApiService.getTopic(id);
    emit(TopicLoadedState(topic: topicModel));
  }

  void deleteTopic(String id) async {
    emit(TopicDeletingState());
    await ApiService.deleteTopic(id);
    topicListBloc.loadTopics();
  }
}
