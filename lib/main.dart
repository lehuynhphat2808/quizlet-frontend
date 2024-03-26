import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/main/main_page.dart';
import 'package:quizlet_frontend/topic/bloc/topic_bloc.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/word/bloc/word_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TopicListBloc>(
        create: (context) => TopicListBloc(),
      ),
      BlocProvider<WordCubit>(
        create: (context) => WordCubit(),
      )
    ],
    child: const MaterialApp(
      initialRoute: Routes.mainPage,
      onGenerateRoute: RouteGenerator.getRoute,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    ),
  ));
}
