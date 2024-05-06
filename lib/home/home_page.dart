import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizlet_frontend/folder/add_folder_model.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';

import '../topic/topic_model.dart';
import '../utilities/router_manager.dart';

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
      body: FutureBuilder(
        future: ApiService.getPageTopicPublic(),
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
            return CircularProgressIndicator();
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              setState(() {
                widget.topics!.removeAt(index);
              });
              widget.updateFolder(widget.topics!.map((e) => e.id!).toList());
              print('folderModel.topics: ${widget.topics}');
            },
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text(
                        "Are you sure you wish to delete this word?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: Icon(
                  Icons.delete,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            key: UniqueKey(),
            child: _buildTopicItem(widget.topics![index], index, context));
      },
      itemCount: widget.topics?.length ?? 0,
    );
  }

  Widget _buildTopicItem(
      TopicModel topicModel, int index, BuildContext context) {
    print('_buildTopicItem: $index');
    print('topicModel: ${topicModel.wordCount}');
    Random random = Random();
    var randomImage =
        NetworkImage('https://picsum.photos/id/${random.nextInt(100)}/250');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.topicPage,
            arguments: topicModel.id);
      },
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
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
                    image:
                        DecorationImage(image: randomImage, fit: BoxFit.fill),
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
}
