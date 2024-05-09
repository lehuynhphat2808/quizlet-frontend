import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:quizlet_frontend/games/multiple_choice_game.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/utilities/list_util.dart';

import '../word/word_model.dart';

class LearningPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const LearningPage({super.key, required this.wordModels});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int currentItem = 0;
  final List<String> wordIdList = [];

  @override
  Widget build(BuildContext context) {
    int maxAnswer = widget.wordModels.length < 4 ? widget.wordModels.length : 4;
    List<String> randomWordList = [];
    Random random = Random();
    randomWordList.add(widget.wordModels[currentItem].definition!);

    while (randomWordList.length != maxAnswer) {
      var rd = random.nextInt(widget.wordModels.length);
      if (!randomWordList.contains(widget.wordModels[rd].definition!)) {
        randomWordList.add(widget.wordModels[rd].definition!);
      }
    }
    shuffle(randomWordList);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learning Page',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800]),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[800],
            size: 30,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.grey[800],
              ))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressBar(
            maxSteps: widget.wordModels.length,
            progressType:
                LinearProgressBar.progressTypeLinear, // Use Dots progress
            currentStep: currentItem + 1,
            progressColor: Colors.deepPurple,
            backgroundColor: Colors.grey,
          ),
          MultipleChoiceGame(
            currentWord: widget.wordModels[currentItem],
            answerList: randomWordList,
            handleOnOkClick: _addCurrentItem,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _addCurrentItem(bool result) async {
    if (result) {
      wordIdList.add(widget.wordModels[currentItem].id!);
    }
    print('currentItem: $currentItem');
    if (currentItem == widget.wordModels.length - 1) {
      print('wordIdList: $wordIdList');
      await ApiService.learningCount(wordIdList);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        currentItem++;
      });
    }
  }
}
