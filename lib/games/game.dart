import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class LearningGame extends StatefulWidget {
  final WordModel currentWord;
  final List<String> answerList;
  final Function? handleOnOkClick;
  const LearningGame(
      {super.key,
      required this.currentWord,
      required this.answerList,
      this.handleOnOkClick});

  @override
  State<LearningGame> createState() => _LearningGameState();
}

class _LearningGameState extends State<LearningGame> {
  @override
  Widget build(BuildContext context) {
    return _buildLearningGame();
  }

  Widget _buildLearningGame() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                widget.currentWord.name!,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            itemCount: widget.answerList.length,
            itemBuilder: (context, index) {
              return _buildAnswer(widget.answerList[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswer(String text) {
    return TextButton(
      onPressed: () async {
        if (text == widget.currentWord.definition) {
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
              widget.handleOnOkClick!.call();
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
                          widget.currentWord.definition!,
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
              widget.handleOnOkClick!.call();
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
}
