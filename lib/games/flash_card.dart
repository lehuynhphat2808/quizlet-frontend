import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../word/word_model.dart';

class FlashCardPage extends StatefulWidget {
  final List<WordModel> wordModels;
  const FlashCardPage({super.key, required this.wordModels});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  bool isDragging = false;
  int studiedWord = 0;
  int studyingWord = 0;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    for (int i = 0; i < widget.wordModels.length; i++) {
      _swipeItems.add(
        SwipeItem(
          likeAction: () {
            setState(() {
              studiedWord++;
            });
          },
          nopeAction: () {
            setState(() {
              studyingWord++;
            });
          },

          // superlikeAction: () {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text("Superliked ${_names[i]}"),
          //     duration: Duration(milliseconds: 500),
          //   ));
          // },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          },
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Column(
        children: [
          LinearProgressBar(
            maxSteps: 3,
            progressType:
                LinearProgressBar.progressTypeLinear, // Use Dots progress
            currentStep: 1,
            progressColor: Colors.deepPurple,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.25),
                    border: Border.all(color: Colors.orange.withOpacity(0.6)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(50))),
                child: Container(
                  width: 35,
                  height: 25,
                  alignment: Alignment.center,
                  child: Text(
                    '$studiedWord',
                    style: const TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.25),
                    border:
                        Border.all(color: Colors.greenAccent.withOpacity(0.6)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50))),
                child: Container(
                  width: 35,
                  height: 25,
                  alignment: Alignment.center,
                  child: Text(
                    '$studyingWord',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: SwipeCards(
                  matchEngine: _matchEngine!,
                  likeTag: const Text('Đang học'),
                  nopeTag: const Text('Đã học'),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCardWordItem(widget.wordModels[index]);
                  },
                  onStackFinished: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Stack Finished"),
                      duration: Duration(milliseconds: 500),
                    ));
                  },
                  leftSwipeAllowed: true,
                  rightSwipeAllowed: true,
                  upSwipeAllowed: true,
                  fillSpace: false,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.reply,
                size: 35,
                color: Colors.grey[400],
              ),
              const SizedBox(
                width: 20,
              ),
              const SizedBox(
                width: 200,
                child: Text(
                  'Vuốt sang phải để đánh dấu Đang Học',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Icon(
                Icons.play_arrow_rounded,
                size: 35,
                color: Colors.grey[600],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCardWordItem(WordModel wordModel) {
    return FlipCard(
      // fill: Fill
      //     .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      side: CardSide.FRONT, // The side to initially display.
      front: Container(
        child: _buildCardWord(wordModel.name!),
      ),
      back: _buildCardWord(wordModel.definition!),
    );
  }

  Widget _buildCardWord(String word) {
    return Card(
      color: Colors.white,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: isDragging ? Border.all(color: Colors.red) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            word,
            style: const TextStyle(fontSize: 30),
          )),
    );
  }
}
