import 'package:flutter/material.dart';
import 'package:quizlet_frontend/topic/topic_page.dart';
import 'package:quizlet_frontend/add_page/add_topic_page.dart';
import 'package:quizlet_frontend/main/main_page.dart';

class Routes {
  static const String mainPage = "/";
  static const String addPage = "/addpage";
  static const String topicPage = "/topic";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.addPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const AddPage());
      case Routes.topicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TopicPage(
                  TOPIC_ID: routeSettings.arguments.toString(),
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
