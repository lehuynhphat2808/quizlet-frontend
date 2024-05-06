import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizlet_frontend/folder/add_folder_model.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_list_page.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';

import '../topic/topic_list_bloc/topic_list_bloc.dart';
import '../topic/topic_list_bloc/topic_list_event.dart';
import '../topic/topic_list_bloc/topic_list_state.dart';

class AddFolderPage extends StatefulWidget {
  final FolderModel? folderModel;
  const AddFolderPage({
    super.key,
    this.folderModel,
  });

  @override
  State<AddFolderPage> createState() => _AddFolderPageState();
}

class _AddFolderPageState extends State<AddFolderPage> {
  final List<bool> pickedList = [];
  final List<String> topicIdList = [];
  AddFolderModel addFolderModel = AddFolderModel();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('build _AddFolderPageState');
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.folderModel == null ? "Create Folder" : "Update Folder",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "Pacifico"),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print('topicIdList: $topicIdList');
                  for (int i = 0; i < pickedList.length; i++) {
                    if (pickedList[i]) {
                      addFolderModel.topicIds.add(topicIdList[i]);
                    }
                  }
                  if (widget.folderModel == null) {
                    await ApiService.addFolder(addFolderModel);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    await ApiService.updateFolder(
                        widget.folderModel!.id, addFolderModel);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                }
                print('pickedList: $pickedList');
              },
              icon: const Icon(
                Icons.done,
                size: 32,
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: widget.folderModel?.name,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Name Folder',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  addFolderModel.name = value;
                  return null;
                },
                onSaved: (newValue) {},
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Name Folder',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: TopicList(
                pickedList: pickedList,
                topicIdList: topicIdList,
                folderModel: widget.folderModel,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicList extends StatefulWidget {
  final List<bool> pickedList;
  final List<String> topicIdList;
  final FolderModel? folderModel;

  const TopicList(
      {super.key,
      required this.pickedList,
      required this.topicIdList,
      this.folderModel});

  @override
  State<TopicList> createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  @override
  Widget build(BuildContext context) {
    print('build _TopicListState');
    return _buildListTopic;
  }

  Widget get _buildListTopic {
    return BlocBuilder<TopicListBloc, TopicListState>(
      builder: (BuildContext builderContext, TopicListState state) {
        print('state: $state');
        if (state is TopicListInitialState) {
          context.read<TopicListBloc>().add(TopicListLoadingEvent());
        }
        if (state is TopicListLoadingState) {
          return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.grey[300]!, size: 40));
        } else if (state is TopicListLoadedState) {
          if (widget.pickedList.isEmpty) {
            widget.pickedList
                .addAll(List.generate(state.topics.length, (index) {
              if (widget.folderModel != null) {
                if (widget.folderModel!.topics != null) {
                  for (TopicModel topicModel in widget.folderModel!.topics!) {
                    if (topicModel.id! == state.topics[index].id!) {
                      return true;
                    }
                  }
                }
              }
              return false;
            }));
            if (widget.topicIdList.isEmpty) {
              widget.topicIdList
                  .addAll(state.topics.map((e) => e.id!).toList());
            }
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return _buildTopicItem(state.topics[index], index);
            },
            itemCount: state.topics.length,
          );
        }
        return _buildEmptyTodoBackground();
      },
    );
  }

  Widget _buildEmptyTodoBackground() {
    return AspectRatio(
        aspectRatio: 1,
        child: Image.asset('assets/images/img_empty_todo_list.jpg'));
  }

  Widget _buildTopicItem(TopicModel topicModel, int index) {
    print('topicModel: ${topicModel.wordCount}');
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.pickedList[index] = !widget.pickedList[index];
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: (widget.pickedList[index])
                ? Border.all(color: Colors.black, width: 1)
                : null,
            borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          margin: const EdgeInsets.all(1),
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
                            backgroundImage:
                                NetworkImage(topicModel.owner!.avatar),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${topicModel.owner?.nickname}',
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
      ),
    );
  }
}
