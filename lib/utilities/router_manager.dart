import 'package:flutter/material.dart';
import 'package:quizlet_frontend/folder/folder_detail_page.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/folder/update_folder_page.dart';
import 'package:quizlet_frontend/games/card_pairing_game.dart';
import 'package:quizlet_frontend/games/learning_page.dart';
import 'package:quizlet_frontend/games/test_page.dart';
import 'package:quizlet_frontend/games/typing_page.dart';
import 'package:quizlet_frontend/leading_board_page/leading_board_page.dart';
import 'package:quizlet_frontend/login/login_page.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/topic/topic_page.dart';
import 'package:quizlet_frontend/add_page/update_topic_page.dart';
import 'package:quizlet_frontend/main/main_page.dart';
import 'package:quizlet_frontend/games/flash_card_page.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class Routes {
  static const String loginPage = "/loginPage";
  static const String mainPage = "/";
  static const String leadingBoadPage = "/leadingBoad";
  static const String updateTopicPage = "/updateTopicPage";
  static const String updateFolderPage = "/updateFolderPage";
  static const String topicPage = "/topic";
  static const String folderDetailPage = "/folderDetailPage";
  static const String flashCardPage = '/flashCard';
  static const String learningPage = '/learningPage';
  static const String testPage = '/testPage';
  static const String typingPage = '/typingPage';
  static const String cardPairing = '/cardPairing';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.loginPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const LoginPage());
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.leadingBoadPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => LeadingBoardPage(
                  id: routeSettings.arguments.toString(),
                ));
      case Routes.updateTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => AddPage(
                  topicModel: routeSettings.arguments == null
                      ? null
                      : routeSettings.arguments as TopicModel,
                ));
      case Routes.updateFolderPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => AddFolderPage(
                  folderModel: routeSettings.arguments == null
                      ? null
                      : routeSettings.arguments as FolderModel,
                ));
      case Routes.topicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TopicPage(
                  TOPIC_ID: routeSettings.arguments.toString(),
                ));
      case Routes.folderDetailPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FolderDetailPage(
                  id: routeSettings.arguments.toString(),
                ));
      case Routes.flashCardPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FlashCardPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));
      case Routes.learningPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => LearningPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));
      case Routes.testPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TestPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));
      case Routes.typingPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TypingPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));
      case Routes.cardPairing:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => CardPairingGame(
                wordList: routeSettings.arguments as List<WordModel>));
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
