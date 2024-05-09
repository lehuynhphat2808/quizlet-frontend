import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class YesNoGame extends StatefulWidget {
  final WordModel currentWord;
  final String answer;
  final Function? handleOnOkClick;
  const YesNoGame(
      {super.key,
      required this.currentWord,
      this.handleOnOkClick,
      required this.answer});

  @override
  State<YesNoGame> createState() => _YesNoGameState();
}

class _YesNoGameState extends State<YesNoGame> {
  bool result = false;

  @override
  Widget build(BuildContext context) {
    result = false;
    return _buildYesNoGame();
  }

  Widget _buildYesNoGame() {
    print('currentWord.name: ${widget.currentWord.name}');
    print('answer: ${widget.answer}');

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.currentWord.name!,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.answer,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ],
            ),
          ),
          _buildAnswer('Yes'),
          _buildAnswer('No'),
        ],
      ),
    );
  }

  Widget _buildAnswer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      width: double.maxFinite,
      child: TextButton(
        onPressed: () async {
          print(
              'widget.answer: ${widget.answer}, widget.currentWord.definition: ${widget.currentWord.definition} ');
          print(
              'widget.answer == widget.currentWord.definition: ${widget.answer == widget.currentWord.definition}');
          if (widget.answer == widget.currentWord.definition) {
            if (text == 'Yes') {
              result = true;
              _showCorrectDialog();
            } else {
              _showWrongDialog();
            }
          } else {
            if (text == "No") {
              result = true;
              _showCorrectDialog();
            } else {
              _showWrongDialog();
            }
          }
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.grey[400]!)),
        ),
        child: Text(
          text,
          style:
              TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void _showCorrectDialog() {
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "Continue",
      btnOkOnPress: () {
        widget.handleOnOkClick!.call(result);
      },
    ).show();
  }

  void _showWrongDialog() {
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
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/sad_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const SizedBox(
                    width: 240,
                    child: Text(
                      'You are wrong! This is not correct answer',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    'Match',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    widget.currentWord.definition!,
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
        widget.handleOnOkClick!.call(result);
      },
    ).show();
  }
}
