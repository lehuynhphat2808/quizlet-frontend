import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/word/bloc/word_state.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class WordCubit extends Cubit<WordState> {
  WordCubit() : super(WordInitialState());

  void addWord(WordModel wordModel) async {
    emit(WordLoadingState());
    await ApiService.addWord(wordModel);
    emit(WordLoadedState());
  }
}
