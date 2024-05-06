import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class EssayGame extends StatefulWidget {
  final WordModel currentWord;
  final Function? handleOnOkClick;
  const EssayGame({super.key, required this.currentWord, this.handleOnOkClick});

  @override
  State<EssayGame> createState() => _EssayGameState();
}

class _EssayGameState extends State<EssayGame> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

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
          Container(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
              child: TextField(
                decoration: const InputDecoration(hintText: "Your answer"),
                controller: _textEditingController,
                onSubmitted: (value) {
                  if (value == widget.currentWord.definition) {
                    _showCorrectDialog();
                  } else {
                    _showWrongDialog();
                  }
                },
              ))
        ],
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
        widget.handleOnOkClick!.call();
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
                    widget.currentWord.name!,
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
                    _textEditingController.text,
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
        setState(() {
          _textEditingController.text = '';
        });
      },
    ).show();
  }
}
