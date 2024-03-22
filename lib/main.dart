import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_frontend/home/HomePage.dart';
import 'package:quizlet_frontend/main/MainPage.dart';
import 'package:quizlet_frontend/login/LoginPage.dart';
import 'package:quizlet_frontend/topic/bloc/topic_bloc.dart';
import 'package:quizlet_frontend/utilities/testApiCall.dart';
import 'package:quizlet_frontend/Topic/TopicProvider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TopicProvider()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<TopicListBloc>(
          create: (context) => TopicListBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    ),
  ));
}
