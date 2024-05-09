import 'dart:io';
import 'dart:math';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_bloc.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_state.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/utilities/tts_uti.dart';
import 'package:quizlet_frontend/word/word_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translator/translator.dart';

class TopicPage extends StatefulWidget {
  final String TOPIC_ID;
  const TopicPage({super.key, required this.TOPIC_ID});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  bool reset = false;
  bool isBack = false;
  bool defaultOrder = true;
  TopicModel? topicModel;
  Credentials? credentials;
  final TextStyle listTileTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
  final pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    context.read<TopicCubit>().getTopic(widget.TOPIC_ID);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you want export csv file'),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Yes'),
                        onPressed: () async {
                          await _exportCsv();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Csv was exported to Download'),
                              ),
                            );

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.share)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz,
            ),
            onPressed: () {
              (topicModel != null &&
                      topicModel!.owner!.id == ApiService.userModel.id)
                  ? _showAddBottomPopup()
                  : null;
            },
          ),
        )
      ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TopicCubit, TopicState>(
      builder: (BuildContext context, state) {
        if (state is TopicLoadedState) {
          topicModel = state.topic;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: pageController,
                    itemBuilder: (context, index) =>
                        // _buildCardWordItem(topicModel!.words![index]),
                        MyCardWord(wordModel: topicModel!.words![index]),
                    itemCount: topicModel!.words?.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                topicModel!.words!.isEmpty
                    ? const SizedBox(
                        height: 10,
                      )
                    : Center(
                        child: SmoothPageIndicator(
                            controller: pageController,
                            count: topicModel!.words!.length,
                            effect: const WormEffect(dotHeight: 6, dotWidth: 6),
                            onDotClicked: (index) {}),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        topicModel!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(topicModel!.owner!.avatar),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            topicModel!.owner!.nickname,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              thickness: 2,
                              indent: 2,
                              endIndent: 2,
                            ),
                          ),
                          Text(
                            '${topicModel!.words!.length} words',
                            style: const TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      _buildListCardPlay(topicModel!.words!),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Words',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  defaultOrder = !defaultOrder;
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  'Default order',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[800]),
                                ),
                                trailing: defaultOrder
                                    ? const Icon(
                                        FontAwesomeIcons.arrowDownWideShort,
                                        size: 16,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.arrowDownAZ,
                                        size: 16,
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: topicModel!.words!.length,
                        itemBuilder: (context, index) {
                          return _buildCardWords(topicModel!.words![index]);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color(0xFFEA3799),
              size: 60,
            ),
          );
        }
      },
    );
  }

  void _getSide(bool value) {
    isBack = value;
  }

  Widget _buildListCardPlay(List<WordModel> wordModels) {
    var mySliderKey = GlobalKey<MySliderState>();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (topicModel!.words!.isNotEmpty) {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Column(
                  children: [
                    const Text(
                      'Setting for FlashCard',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Choose the number of words to learn'),
                    MySlider(
                      key: mySliderKey,
                      max: wordModels.length.toDouble(),
                    ),
                    MyRBtn(getValue: _getSide),
                  ],
                ),
                btnOkOnPress: () async {
                  var reset = await Navigator.pushNamed(
                      context, Routes.flashCardPage,
                      arguments: [
                        _getRandomWordList(
                          mySliderKey.currentState!.currentSliderValue.toInt(),
                        ),
                        isBack
                      ]);
                  if (reset != null && reset == true && mounted) {
                    context.read<TopicCubit>().getTopic(widget.TOPIC_ID);

                    setState(() {});
                  }
                },
                btnCancelOnPress: () {},
              ).show();
            }
          },
          child: Card(
            color: topicModel!.words!.isEmpty
                ? Colors.grey.withOpacity(0.3)
                : null,
            child: ListTile(
              title: Text(
                'Flash Card',
                style: listTileTextStyle,
              ),
              leading: Image.asset('assets/images/flash_card.png', height: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (topicModel!.words!.isNotEmpty) {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Column(
                  children: [
                    const Text(
                      'Setting for Learning',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Choose the number of words to learn'),
                    MySlider(
                      key: mySliderKey,
                      max: wordModels.length.toDouble(),
                    ),
                  ],
                ),
                btnOkOnPress: () async {
                  var reset = await Navigator.pushNamed(
                      context, Routes.learningPage,
                      arguments: _getRandomWordList(mySliderKey
                          .currentState!.currentSliderValue
                          .toInt()));
                  if (reset != null && reset == true && mounted) {
                    context.read<TopicCubit>().getTopic(widget.TOPIC_ID);

                    setState(() {});
                  }
                },
                btnCancelOnPress: () {},
              ).show();
            }
          },
          child: Card(
            color: topicModel!.words!.isEmpty
                ? Colors.grey.withOpacity(0.3)
                : null,
            child: ListTile(
              title: Text(
                'Learning',
                style: listTileTextStyle,
              ),
              leading: Image.asset('assets/images/learning.png', height: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (topicModel!.words!.isNotEmpty) {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Column(
                  children: [
                    const Text(
                      'Setting for Typing',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Choose the number of words to learn'),
                    MySlider(
                      key: mySliderKey,
                      max: wordModels.length.toDouble(),
                    )
                  ],
                ),
                btnOkOnPress: () async {
                  var reset = await Navigator.pushNamed(
                    context,
                    Routes.typingPage,
                    arguments: _getRandomWordList(
                      mySliderKey.currentState!.currentSliderValue.toInt(),
                    ),
                  );
                  if (reset != null && reset == true && mounted) {
                    context.read<TopicCubit>().getTopic(widget.TOPIC_ID);

                    setState(() {});
                  }
                },
                btnCancelOnPress: () {},
              ).show();
            }
          },
          child: Card(
            color: topicModel!.words!.isEmpty
                ? Colors.grey.withOpacity(0.3)
                : null,
            child: ListTile(
              title: Text(
                'Typing',
                style: listTileTextStyle,
              ),
              leading: Image.asset('assets/images/test_icon.png', height: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (topicModel!.words!.isNotEmpty) {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Column(
                  children: [
                    const Text(
                      'Setting for Test',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Choose the number of words to learn'),
                    MySlider(
                      key: mySliderKey,
                      max: wordModels.length.toDouble(),
                    )
                  ],
                ),
                btnOkOnPress: () {
                  Navigator.pushNamed(context, Routes.testPage,
                      arguments: _getRandomWordList(mySliderKey
                          .currentState!.currentSliderValue
                          .toInt()));
                },
                btnCancelOnPress: () {},
              ).show();
            }
          },
          child: Card(
            color: topicModel!.words!.isEmpty
                ? Colors.grey.withOpacity(0.3)
                : null,
            child: ListTile(
              title: Text(
                'Test',
                style: listTileTextStyle,
              ),
              leading: Image.asset('assets/images/test_icon.png', height: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (topicModel!.words!.isNotEmpty) {
              var score = await Navigator.pushNamed(context, Routes.cardPairing,
                  arguments: _getRandomWordList(6));
              if (score != null) {
                await ApiService.addScore(widget.TOPIC_ID, score as int);
              }
            }
          },
          child: Card(
            color: topicModel!.words!.isEmpty
                ? Colors.grey.withOpacity(0.3)
                : null,
            child: ListTile(
              title: Text(
                'Card pairing',
                style: listTileTextStyle,
              ),
              leading:
                  Image.asset('assets/images/card_pairing.png', height: 20),
            ),
          ),
        ),
        topicModel!.public!
            ? GestureDetector(
                onTap: () {
                  if (topicModel!.words!.isNotEmpty) {
                    Navigator.pushNamed(context, Routes.leadingBoadPage,
                        arguments: topicModel!.id);
                  }
                },
                child: Card(
                  color: topicModel!.words!.isEmpty
                      ? Colors.grey.withOpacity(0.3)
                      : null,
                  child: ListTile(
                    title: Text(
                      'Leading Board',
                      style: listTileTextStyle,
                    ),
                    leading: Image.asset('assets/images/leading_board_icon.png',
                        height: 20),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _getStatus(double num) {
    if (num < 25) {
      return Text(
        'Not learned',
        style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
      );
    }
    if (num < 75) {
      return Text(
        'Learned',
        style: TextStyle(color: Colors.orange, fontSize: 12),
      );
    }
    return Text(
      'Memorized',
      style: TextStyle(color: Colors.green, fontSize: 12),
    );
  }

  Widget _buildCardWords(WordModel wordModel) {
    print('wordModel: ${wordModel.learningCount}');
    return SizedBox(
      height: 115,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${wordModel.name}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await speak(wordModel.name);
                              },
                              icon: const Icon(Icons.volume_up),
                            ),
                            if (wordModel.marked!)
                              IconButton(
                                  onPressed: () async {
                                    await ApiService.unMarking([wordModel.id!]);
                                    setState(() {
                                      wordModel.marked = false;
                                      reset = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ))
                            else
                              IconButton(
                                  onPressed: () async {
                                    await ApiService.markWord([wordModel.id!]);
                                    setState(() {
                                      wordModel.marked = true;
                                      reset = true;
                                    });
                                  },
                                  icon: const Icon(Icons.star_outline_sharp)),
                          ],
                        )
                      ],
                    ),
                    Text(
                      '${wordModel.definition}',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 2.0,
              percent: wordModel.learningCount! < 20
                  ? (wordModel.learningCount! / 20)
                  : 1,
              center: _getStatus(
                (wordModel.learningCount! / 20) * 100,
              ),
              progressColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  List<WordModel> _getRandomWordList(int size) {
    List<WordModel> randomWordList = [];
    Random random = Random();
    int maxAnswer =
        topicModel!.words!.length < size ? topicModel!.words!.length : size;

    while (randomWordList.length != maxAnswer) {
      bool isExist = false;
      print('randomWordList.length: ${randomWordList.length}');
      var rd = random.nextInt(topicModel!.words!.length);
      for (int i = 0; i < randomWordList.length; i++) {
        if (randomWordList[i].id == topicModel!.words![rd].id) {
          isExist = true;
          break;
        }
      }
      if (!isExist) {
        randomWordList.add(topicModel!.words![rd]);
      }
    }
    return randomWordList;
  }

  void _showAddBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buidPopupChoose(),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buidPopupChoose() {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))),
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: const ListTile(
              leading: Icon(
                Icons.folder_outlined,
                size: 28,
              ),
              title: Text(
                "Add to Folder",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))),
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: GestureDetector(
            onTap: () {
              if (topicModel != null) {
                Navigator.pushNamed(context, Routes.updateTopicPage,
                    arguments: topicModel);
              }
            },
            child: const ListTile(
                leading: Icon(
                  Icons.copy,
                  size: 28,
                ),
                title: Text(
                  "Save and Edit",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))),
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: const ListTile(
              leading: Icon(
                CupertinoIcons.share,
                size: 28,
              ),
              title: Text(
                "Share",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))),
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: const ListTile(
              leading: Icon(
                Icons.info_outline,
                size: 28,
              ),
              title: Text(
                "Information of Topic",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
        ),
        GestureDetector(
          onTap: () {
            context.read<TopicCubit>().deleteTopic(widget.TOPIC_ID);
            Navigator.popUntil(context, ModalRoute.withName(Routes.mainPage));
          },
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey))),
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: const ListTile(
                leading: Icon(
                  Icons.delete,
                  size: 28,
                ),
                title: Text(
                  "Delete Topic",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
          ),
        ),
      ],
    );
  }

  Future<void> _exportCsv() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<dynamic> associateList = [];
    for (WordModel wordModel in topicModel!.words!) {
      associateList
          .add({'Word': wordModel.name, "Definition": wordModel.definition});
    }

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("Word");
    row.add("Definition");
    rows.add(row);
    for (int i = 0; i < associateList.length; i++) {
      List<dynamic> row = [];
      row.add(associateList[i]["Word"]);
      row.add(associateList[i]["Definition"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File("$file/${topicModel!.name}.csv");

    f.writeAsString(csv);
  }
}

class MySlider extends StatefulWidget {
  final double max;
  const MySlider({super.key, required this.max});

  @override
  State<MySlider> createState() => MySliderState();
}

class MySliderState extends State<MySlider> {
  double currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text(
            '${currentSliderValue.toInt()}/${widget.max.toInt()}',
          ),
        ),
        Slider(
          value: currentSliderValue,
          max: widget.max,
          divisions: widget.max.toInt(),
          label: currentSliderValue.round().toString(),
          onChanged: (double value) {
            if (value < 1) {
              currentSliderValue = 1;
            } else {
              setState(() {
                currentSliderValue = value;
              });
            }
          },
        ),
      ],
    );
  }
}

class MyCardWord extends StatefulWidget {
  final WordModel wordModel;
  const MyCardWord({super.key, required this.wordModel});

  @override
  State<MyCardWord> createState() => _MyCardWordState();
}

class _MyCardWordState extends State<MyCardWord> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return _buildCardWordItem(widget.wordModel);
  }

  Widget _buildCardWordItem(WordModel wordModel) {
    print('wordModel: ${wordModel.toJson()}');
    return FlipCard(
      // fill: Fill
      //     .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      onFlip: () {
        setState(() {
          isEnglish = !isEnglish;
        });
        print('isEnglish: $isEnglish');
      },
      side: CardSide.FRONT, // The side to initially display.
      front: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: _buildCardWord(wordModel.name!, isEnglish),
      ),
      back: _buildCardWord(wordModel.definition!, isEnglish),
    );
  }

  Widget _buildCardWord(String word, bool isEnglish) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Card(
            color: Colors.white,
            child: Container(alignment: Alignment.center, child: Text(word)),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(
                Icons.zoom_out_map,
                color: Colors.grey,
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(
                Icons.volume_up,
                color: Colors.grey,
                size: 25,
              ),
              onPressed: () async {
                print('isEnglish: $isEnglish');
                if (!isEnglish) {
                  Translation translation = await word.translate();
                  var lanCode = translation.sourceLanguage.code;
                  print("Language Code: $lanCode");

                  await speak(word);
                } else {
                  await speak(word);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MyRBtn extends StatefulWidget {
  final Function getValue;
  const MyRBtn({super.key, required this.getValue});

  @override
  State<MyRBtn> createState() => _MyRBtnState();
}

class _MyRBtnState extends State<MyRBtn> {
  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('FRONT'),
          value: false,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
            widget.getValue(selectedValue);
          },
        ),
        RadioListTile(
          title: const Text('BACK'),
          value: true,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
            widget.getValue(selectedValue);
          },
        ),
      ],
    );
  }
}
