import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/main/main_page.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_bloc.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_bloc.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/word/bloc/word_bloc.dart';
import 'package:quizlet_frontend/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TopicListBloc>(
        create: (context) => TopicListBloc(),
      ),
      BlocProvider<TopicCubit>(
        create: (context) =>
            TopicCubit(topicListBloc: BlocProvider.of<TopicListBloc>(context)),
      ),
      BlocProvider<WordCubit>(
        create: (context) => WordCubit(),
      ),
    ],
    child: const MaterialApp(
      initialRoute: Routes.loginPage,
      onGenerateRoute: RouteGenerator.getRoute,
      debugShowCheckedModeBanner: false,
    ),
  ));
}
