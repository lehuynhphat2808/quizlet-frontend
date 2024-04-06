import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../word/word_model.dart';

class LearningPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const LearningPage({super.key, required this.wordModels});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int currentItem = 0;
  @override
  Widget build(BuildContext context) {
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
          _buildLearningGame(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildLearningGame() {
    int maxAnswer = widget.wordModels.length < 4 ? widget.wordModels.length : 4;
    List<int> randomList = [];
    Random random = Random();
    while (randomList.length != maxAnswer) {
      var rd = random.nextInt(widget.wordModels.length);
      if (!randomList.contains(rd)) {
        randomList.add(rd);
      }
    }
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                widget.wordModels[currentItem].name!,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            itemCount: maxAnswer,
            itemBuilder: (context, index) {
              return _buildAnswer(
                  widget.wordModels[randomList[index]].definition!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswer(String text) {
    print('buildAnswer');
    return TextButton(
      onPressed: () async {
        if (text == widget.wordModels[currentItem].definition) {
          AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Correct',
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/happy_icon.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Good job!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'You answer is right',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            btnOkText: "Continue",
            btnOkOnPress: () {
              _addCurrentItem();
            },
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Wrong Answer',
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/sad_icon.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Learn this word!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const Text(
                          'Right answer',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          widget.wordModels[currentItem].definition!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        const Text(
                          'You think',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          text,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            btnOkColor: Colors.blue,
            btnOkText: "Continue",
            btnOkOnPress: () {
              _addCurrentItem();
            },
          ).show();
        }
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.grey[400]!)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w400),
      ),
    );
  }

  void _addCurrentItem() {
    print('currentItem: $currentItem');
    if (currentItem == widget.wordModels.length - 1) {
      Navigator.pop(context);
    } else {
      setState(() {
        currentItem++;
      });
    }
  }
}
