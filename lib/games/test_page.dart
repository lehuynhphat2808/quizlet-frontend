import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:quizlet_frontend/games/essay_questions.dart';
import 'package:quizlet_frontend/games/multiple_choice_game.dart';
import 'package:quizlet_frontend/games/yesno_game.dart';

import '../services/api_service.dart';
import '../utilities/list_util.dart';
import '../word/word_model.dart';

class TestPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const TestPage({super.key, required this.wordModels});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentItem = 0;
  final List<String> wordIdList = [];

  @override
  Widget build(BuildContext context) {
    late Widget questionWidget;
    Random random = Random();
    var randomCase = random.nextInt(3);
    print('randomCase: $randomCase');
    switch (randomCase) {
      case 0:
        questionWidget = YesNoGame(
          currentWord: widget.wordModels[currentItem],
          answer: widget
              .wordModels[random.nextInt(widget.wordModels.length)].definition!,
          handleOnOkClick: _nextWord,
        );
      case 1:
        int maxAnswer =
            widget.wordModels.length < 4 ? widget.wordModels.length : 4;
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
        questionWidget = MultipleChoiceGame(
          currentWord: widget.wordModels[currentItem],
          answerList: randomWordList,
          handleOnOkClick: _nextWord,
        );
      case 2:
        questionWidget = EssayGame(
          currentWord: widget.wordModels[currentItem],
          handleOnOkClick: _nextWord,
        );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          )
        ],
        title: Text(
          '${currentItem + 1}/${widget.wordModels.length}',
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        LinearProgressBar(
          maxSteps: widget.wordModels.length,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Dots progress
          currentStep: currentItem + 1,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.grey,
        ),
        questionWidget,
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  void _nextWord(bool result) async {
    if (result) {
      wordIdList.add(widget.wordModels[currentItem].id!);
    }

    print('currentItem: $currentItem');
    if (currentItem == widget.wordModels.length - 1) {
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
