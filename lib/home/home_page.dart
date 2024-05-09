import 'dart:math';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizlet_frontend/folder/add_folder_model.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';

import '../topic/topic_model.dart';
import '../utilities/router_manager.dart';

Widget _buildTopicItem(TopicModel topicModel, int index, BuildContext context) {
  print('_buildTopicItem: $index');
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, Routes.topicPage, arguments: topicModel.id);
    },
    child: Card(
      color: Colors.grey,
      elevation: 5,
      shadowColor: Colors.grey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                foregroundDecoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black12,
                      Colors.black26,
                      Colors.black38,
                      Colors.black45,
                      Colors.black54,
                      Colors.black87,
                    ],
                    tileMode: TileMode.mirror,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 0.55, 0.65, 0.75, 0.8, 0.85, 1],
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                  // image: DecorationImage(image: randomImage, fit: BoxFit.fill),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(topicModel.url),
                    placeholder: const AssetImage('assets/images/topic.png'),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Image.asset(
                          'assets/images/topic.png',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              topicModel.name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              '${topicModel.wordCount} words',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      topicModel.owner == null
                                          ? ApiService.userModel.avatar
                                          : topicModel.owner!.avatar),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  topicModel.owner == null
                                      ? ApiService.userModel.nickname
                                      : topicModel.owner!.nickname,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FolderModel folderModel;

  @override
  Widget build(BuildContext context) {
    print('build _HomePageState}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Hone",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(context: context, delegate: SearchField());
            },
          )
        ],
        elevation: 4,
      ),
      body: FutureBuilder(
        future: ApiService.getPageTopicPublic(size: 10),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            PageResponse pageResponse = snapshot.data;
            List<TopicModel> topicModelList =
                TopicModel.getTopicModelList(pageResponse.items);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: ListViewTopic(
                    topics: topicModelList,
                    updateFolder: _updateFolder,
                  )),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.grey[300]!, size: 40));
          }
        },
      ),
    );
  }

  void _updateFolder(List<String> topicIds) async {
    await ApiService.updateFolder(folderModel.id,
        AddFolderModel(name: folderModel.name, topicIds: topicIds));
  }
}

class ListViewTopic extends StatefulWidget {
  final Function updateFolder;
  final List<TopicModel>? topics;
  const ListViewTopic({
    super.key,
    this.topics,
    required this.updateFolder,
  });

  @override
  State<ListViewTopic> createState() => _ListViewTopicState();
}

class _ListViewTopicState extends State<ListViewTopic> {
  late ScrollController _scrollController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      PageResponse pageResponse =
          await ApiService.getPageTopicPublic(page: _currentPage, size: 10);
      List<TopicModel> topicModelList =
          TopicModel.getTopicModelList(pageResponse.items);
      if (topicModelList.isEmpty) return;
      setState(() {
        widget.topics!.addAll(topicModelList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return _buildTopicItem(widget.topics![index], index, context);
      },
      itemCount: widget.topics?.length ?? 0,
    );
  }
}

class SearchField extends SearchDelegate {
  Future<List<TopicModel>> _loadFromApi(String searchData) async {
    PageResponse pageResponse =
        await ApiService.getPageTopicPublic(name: searchData);
    return TopicModel.getTopicModelList(pageResponse.items);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _loadFromApi(query),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<TopicModel> topicModelList = snapshot.data;
          return ListView.builder(
            itemCount: topicModelList.length,
            itemBuilder: (context, index) {
              TopicModel topicModel = topicModelList[index];
              return _buildTopicItem(topicModel, index, context);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _loadFromApi(query),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<TopicModel> topicModelList = snapshot.data;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemExtent: 75,
            itemCount: topicModelList.length,
            itemBuilder: (context, index) {
              TopicModel topicModel = topicModelList[index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Routes.topicPage,
                      arguments: topicModel.id);
                },
                leading: SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        topicModel.url,
                      ),
                      placeholder: const AssetImage('assets/images/topic.png'),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/topic.png');
                      },
                    ),
                  ),
                ),
                title: Text(topicModel.name!),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
