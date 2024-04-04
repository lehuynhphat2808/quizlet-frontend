import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/topic/topic_cubit/topic_bloc.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/word/bloc/word_bloc.dart';
import 'package:quizlet_frontend/word/word_model.dart';

import '../topic/topic_list_bloc/topic_list_bloc.dart';
import '../topic/topic_list_bloc/topic_list_event.dart';
import '../topic/topic_list_bloc/topic_list_state.dart';

class AddPage extends StatefulWidget {
  final TopicModel? topicModel;
  const AddPage({super.key, this.topicModel});

  @override
  State<AddPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddPage> {
  final List<WordModel> wordModelList = [];

  int itemWordCount = 2;
  TopicModel newTopic = TopicModel();
  final _formKey = GlobalKey<FormState>();
  late String TOPIC_ID;
  late StreamSubscription _subscription;
  late TopicListBloc topicBloc;

  @override
  void initState() {
    if (widget.topicModel != null) {
      if (widget.topicModel!.words != null &&
          widget.topicModel!.words!.isNotEmpty) {
        itemWordCount = widget.topicModel!.words!.length;
        for (WordModel wordModel in widget.topicModel!.words!) {
          wordModelList.add(wordModel);
        }
      }
    } else {
      wordModelList.add(WordModel());
      wordModelList.add(WordModel());
    }
    topicBloc = BlocProvider.of<TopicListBloc>(context);

    _subscription = topicBloc.stream.listen((state) {
      print('_subscription = topicBloc.stream.listen((state): $state');
      if (state is TopicInsertedState) {
        TOPIC_ID = state.topicModel.id!;
        // add word for new topic
        if (widget.topicModel == null) {
          for (WordModel wordModel in wordModelList) {
            wordModel.topicId = TOPIC_ID;
            context.read<WordCubit>().addWord(wordModel);
          }
          Navigator.pop(context);
        }
        _subscription.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            wordModelList.add(WordModel());

            setState(() {
              itemWordCount++;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.topicModel == null ? "Create Topic" : "Update Topic",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: widget.topicModel?.name,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Topic',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (widget.topicModel == null) {
                    context.read<TopicListBloc>().add(
                          TopicInsertedEvent(
                            topicInfo: TopicModel(name: newValue, public: true),
                          ),
                        );
                  } else {
                    newTopic.id = widget.topicModel!.id;
                    newTopic.name = newValue;
                    for (WordModel wordModel in wordModelList) {
                      wordModel.topicId = widget.topicModel!.id;
                    }
                    newTopic.words = wordModelList;
                    newTopic.public = widget.topicModel!.public;
                    context
                        .read<TopicCubit>()
                        .updateTopic(widget.topicModel!, newTopic);
                    Navigator.popUntil(
                        context, ModalRoute.withName(Routes.topicPage));
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Topic',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: wordModelList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            wordModelList.removeAt(index);
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
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
                          key: Key('Key$index'),
                          child: _buildItemWord(index));
                    }),
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWord(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: wordModelList[index].name,
            decoration: const InputDecoration.collapsed(
              hintText: 'Word',
              border: UnderlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (newValue) {
              wordModelList[index].name = newValue;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Word',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            initialValue: wordModelList[index].definition,
            decoration: const InputDecoration.collapsed(
              hintText: 'Definition',
              border: UnderlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (newValue) {
              wordModelList[index].definition = newValue;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Definition',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}