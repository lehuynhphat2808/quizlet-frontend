import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/word/bloc/word_bloc.dart';
import 'package:quizlet_frontend/word/word_model.dart';

import '../topic/topic_list_bloc/topic_list_bloc.dart';
import '../topic/topic_list_bloc/topic_list_event.dart';
import '../topic/topic_list_bloc/topic_list_state.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddPage> {
  int itemWordCount = 2;
  final _formKey = GlobalKey<FormState>();
  late List<WordModel> wordModelList;
  late String TOPIC_ID;
  late StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    wordModelList = [];
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              itemWordCount++;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Create Topic",
          style: TextStyle(fontWeight: FontWeight.bold),
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
                  final topicBloc = BlocProvider.of<TopicListBloc>(context);
                  context.read<TopicListBloc>().add(
                        TopicInsertedEvent(
                          topicInfo: TopicModel(name: newValue!, public: true),
                        ),
                      );
                  _subscription = topicBloc.stream.listen((state) {
                    print(
                        '_subscription = topicBloc.stream.listen((state): $state');
                    if (state is TopicInsertedState) {
                      TOPIC_ID = state.topicModel.id!;

                      for (WordModel wordModel in wordModelList) {
                        wordModel.topicId = TOPIC_ID;
                        context.read<WordCubit>().addWord(wordModel);
                      }
                      print('DONE DONE DONE DONE DONE DONE DONE DONE DONE ');
                    }

                    _subscription.cancel();
                  });
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
                    shrinkWrap: true,
                    itemCount: itemWordCount,
                    itemBuilder: (context, index) {
                      return _buildItemWord(index);
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
    wordModelList.add(WordModel());
    print(wordModelList.length);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
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
