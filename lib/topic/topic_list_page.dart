import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_bloc.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_event.dart';
import 'package:quizlet_frontend/topic/topic_list_bloc/topic_list_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';

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
    return _buildListTopic;
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
      onTap: () {
        Navigator.pushNamed(context, Routes.topicPage,
            arguments: topicModel.id);
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
