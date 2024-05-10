import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_bloc.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_event.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';
import 'package:quizlet_frontend/word/word_model.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({Key? key}) : super(key: key);

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  @override
  void initState() {
    context.read<TopicListBloc>().add(TopicListLoadingEvent());
    // print(topics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Topic",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () async {
                List<WordModel> wordModelList =
                    await ApiService.getWordMarked();
                Navigator.pushNamed(context, Routes.wordMarkedPage,
                    arguments: TopicModel(
                        name: 'My Favorite Words',
                        words: wordModelList,
                        owner: ApiService.userModel));
              },
              icon: const ImageIcon(
                AssetImage('assets/images/star_icon.png'),
                color: Colors.orange,
              ))
        ],
      ),
      body: _buildListTopic,
    );
  }

  Widget get _buildListTopic {
    return BlocBuilder<TopicListBloc, TopicListState>(
      builder: (BuildContext builderContext, TopicListState state) {
        if (state is TopicListLoadingState) {
          return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.grey[300]!, size: 40));
        } else if (state is TopicListLoadedState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return _buildTopicItem(state.topics[index]);
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

  Widget _buildTopicItem(TopicModel topicModel) {
    print('topicModel: ${topicModel.wordCount}');
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, Routes.topicPage,
            arguments: topicModel.id);
        setState(() {});
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(15)),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }
}
