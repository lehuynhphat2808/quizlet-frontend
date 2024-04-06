import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_bloc.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_state.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/word/word_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopicPage extends StatefulWidget {
  final String TOPIC_ID;
  const TopicPage({super.key, required this.TOPIC_ID});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  bool defaultOrder = true;
  TopicModel? topicModel;
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(CupertinoIcons.share),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
          child: GestureDetector(
              onTap: () {
                _showAddBottomPopup();
              },
              child: const Icon(Icons.more_horiz)),
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
          print('TopicModel: ${topicModel!.words}');
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: pageController,
                    itemBuilder: (context, index) =>
                        _buildCardWordItem(topicModel!.words![index]),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87),
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://vtv1.mediacdn.vn/zoom/628_280/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'lehuynhphat2808',
                            style: TextStyle(
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
                      _buildListCardPlay(),
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

  Widget _buildCardWordItem(WordModel wordModel) {
    return FlipCard(
      // fill: Fill
      //     .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      side: CardSide.FRONT, // The side to initially display.
      front: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: _buildCardWord(wordModel.name!),
      ),
      back: _buildCardWord(wordModel.definition!),
    );
  }

  Widget _buildCardWord(String word) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Card(
            color: Colors.white,
            child: Container(alignment: Alignment.center, child: Text(word)),
          ),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.zoom_out_map,
              color: Colors.grey,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCardPlay() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.flashCardPage,
                arguments: topicModel!.words);
          },
          child: Card(
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
            Navigator.pushNamed(context, Routes.learningPage,
                arguments: topicModel!.words);
          },
          child: Card(
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
            Navigator.pushNamed(context, Routes.testPage,
                arguments: topicModel!.words);
          },
          child: Card(
            child: ListTile(
              title: Text(
                'Test',
                style: listTileTextStyle,
              ),
              leading: Image.asset('assets/images/test_icon.png', height: 20),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'Card pairing',
              style: listTileTextStyle,
            ),
            leading: Image.asset('assets/images/card_pairing.png', height: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildCardWords(WordModel wordModel) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                const Row(
                  children: [
                    Icon(Icons.volume_up),
                    Icon(Icons.star_outline_sharp)
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
    );
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
            Navigator.popUntil(context, ModalRoute.withName(Routes.mainPage)
                // (route) {
                //   print('route.settings.name: ${route.settings.name}');
                //   if (route.settings.name == Routes.topicPage) {
                //     print('return true');
                //     Navigator.pop(context);
                //     return true;
                //   }
                //   return false;
                // },
                );
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
}
