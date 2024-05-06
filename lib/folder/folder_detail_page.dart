import 'package:flutter/material.dart';
import 'package:quizlet_frontend/folder/add_folder_model.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';

import '../topic/topic_model.dart';
import '../utilities/router_manager.dart';

class FolderDetailPage extends StatefulWidget {
  final String id;
  const FolderDetailPage({super.key, required this.id});

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  late FolderModel folderModel;
  @override
  Widget build(BuildContext context) {
    print('build _FolderDetailPageState}');
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Folder Detail',
            style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: "Pacifico"),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () async {
                    bool? update = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Do you want delete this folder'),
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
                              await ApiService.deleteFolder(widget.id);
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                    if (update != null) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(Icons.delete)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
              child: GestureDetector(
                  onTap: () async {
                    var reset = await Navigator.pushNamed(
                        context, Routes.updateFolderPage,
                        arguments: folderModel) as bool?;
                    if (reset != null && reset == true) {
                      print('xxxxxxxxxxxxxxxxx');
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.edit)),
            )
          ]),
      body: FutureBuilder(
        future: ApiService.getFolder(widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            folderModel = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folderModel.name,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                  ),
                  Row(
                    children: [
                      Text('${folderModel.topics?.length ?? 0} topics'),
                      SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            NetworkImage(ApiService.userModel.avatar),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        ApiService.userModel.nickname,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListViewTopic(
                    topics: folderModel.topics,
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
    print('topicModel: ${topicModel.wordCount}');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.topicPage,
            arguments: topicModel.id);
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      topicModel.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${topicModel.wordCount} words'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(topicModel.owner == null
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/topic.png'))),
            ),
          ],
        ),
      ),
    );
  }
}
