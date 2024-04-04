import 'package:flutter/material.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/topic/topic_page.dart';
import 'package:quizlet_frontend/add_page/update_topic_page.dart';
import 'package:quizlet_frontend/main/main_page.dart';
import 'package:quizlet_frontend/games/flash_card.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class Routes {
  static const String mainPage = "/";
  static const String updateTopicPage = "/updateTopicPage";
  static const String topicPage = "/topic";
  static const String flashCardPage = '/flashCard';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.updateTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => AddPage(
                  topicModel: routeSettings.arguments == null
                      ? null
                      : routeSettings.arguments as TopicModel,
                ));
      case Routes.topicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TopicPage(
                  TOPIC_ID: routeSettings.arguments.toString(),
                ));
      case Routes.flashCardPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FlashCardPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No route found'),
              ),
              body: const Center(
                  child: Text(
                'No route found',
                style: TextStyle(color: Colors.white),
              )),
            ));
  }
}
