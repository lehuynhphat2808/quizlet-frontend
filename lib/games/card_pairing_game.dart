import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizlet_frontend/services/api_service.dart';

import '../word/word_model.dart';

int _timeRemaining = 60; // 60 giây

class CardPairingGame extends StatefulWidget {
  final List<WordModel> wordList;
  const CardPairingGame({super.key, required this.wordList});

  @override
  State<CardPairingGame> createState() => _CardPairingGameState();
}

class _CardPairingGameState extends State<CardPairingGame> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cardTextList = [];
    for (WordModel wordModel in widget.wordList) {
      cardTextList.add({wordModel.name!: wordModel.definition!});
      cardTextList.add({wordModel.definition!: wordModel.name!});
    }
    _shuffle(cardTextList);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Card Pairing',
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
      body: MyBody(
        cardTextList: cardTextList,
        topicId: widget.wordList[0].topicId!,
      ),
    );
  }

  void _shuffle(List array) {
    for (var i = array.length - 1; i > 0; i--) {
      var j = Random().nextInt(i + 1);
      var temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }
}

class MyGridView extends StatefulWidget {
  final String topicId;
  final List<Map<String, String>> cardTextList;
  const MyGridView(
      {super.key, required this.cardTextList, required this.topicId});

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  late List<bool> fadedList;
  late List<bool> tappedList;
  Map<String, String> pickedWord = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fadedList = List.filled(widget.cardTextList.length, false);
    tappedList = List.filled(widget.cardTextList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridView(widget.cardTextList);
  }

  Widget _buildGridView(List<Map<String, String>> cardTextList) {
    List<Widget> fadeCardList = List.generate(
      cardTextList.length,
      (index) => GestureDetector(
        onTap: () {
          setState(() {
            tappedList[index] = true;
          });
          if (pickedWord.isEmpty) {
            pickedWord = cardTextList[index];
            pickedWord.addAll({'index': '$index'});
            print('pickedWord: $pickedWord');
          } else {
            if (pickedWord.keys.first == cardTextList[index].values.first) {
              int lastIndex = int.parse(pickedWord['index']!);
              setState(() {
                fadedList[index] = true;
                fadedList[lastIndex] = true;
                ApiService.addScore(widget.topicId, _timeRemaining);
                if (fadedList.every((element) => element)) {
                  Navigator.pop(context);
                }
                pickedWord = {};
              });
            } else {
              print('pppppppppppppppppppppppppppppppp');
              pickedWord = {};
              setState(() {
                tappedList = List.filled(widget.cardTextList.length, false);
              });
            }
          }
        },
        child: FadeCard(
          text: cardTextList[index].keys.first,
          faded: fadedList[index],
          tapped: tappedList[index],
        ),
      ),
    );
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: fadeCardList);
  }
}

class FadeCard extends StatefulWidget {
  final String text;
  final bool faded;
  final bool tapped;
  const FadeCard(
      {super.key,
      required this.text,
      required this.faded,
      required this.tapped});

  @override
  State<FadeCard> createState() => _FadeCardState();
}

class _FadeCardState extends State<FadeCard> {
  @override
  Widget build(BuildContext context) {
    return FadeOut(
      animate: widget.faded,
      child: Card(
        color: widget.tapped ? Colors.purple.withOpacity(0.3) : Colors.white,
        child: Center(
          child: Text(widget.text),
        ),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  final String topicId;

  final List<Map<String, String>> cardTextList;
  const MyBody({super.key, required this.cardTextList, required this.topicId});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text('Your score: $_timeRemaining')],
        ),
        Expanded(
          child: MyGridView(
            cardTextList: widget.cardTextList,
            topicId: widget.topicId,
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining < 1) {
          timer.cancel();
        } else {
          _timeRemaining--;
        }
      });
      print(_timeRemaining);
    });
  }
}
