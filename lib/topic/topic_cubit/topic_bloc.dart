import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_state.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_bloc.dart';
import 'package:quizlet_frontend/word/word_model.dart';

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

  void updateTopic(TopicModel oldTopic, TopicModel newTopic) async {
    print('updateTopic newTopic.words: ${newTopic.words}');

    if (!oldTopic.isSameInformation(newTopic)) {
      emit(TopicUploadingState());
      await ApiService.updateTopic(newTopic);
      emit(TopicUploadedState());
      print('updateTopic newTopic.words: ${newTopic.words}');

      // update word
      if (newTopic.words != null) {
        if (newTopic.words!.isNotEmpty) {
          for (WordModel word in newTopic.words!) {
            print('wordId: ${word.id}');
            print('wordName: ${word.name}');

            int indexWord = oldTopic.indexWord(word.id);
            if (indexWord != -1) {
              await ApiService.updateWord(word);
              oldTopic.removeWordAt(indexWord);
            } else {
              await ApiService.addWord(word);
            }
          }
          for (WordModel wordModel in oldTopic.words!) {
            await ApiService.deleteWord(wordModel.id!);
          }
        }
      }

      topicListBloc.loadTopics();
      getTopic(oldTopic.id!);
    }
  }
}
