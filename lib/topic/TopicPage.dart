import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_frontend/Topic/TopicModel.dart';
import 'package:quizlet_frontend/Topic/TopicProvider.dart';
import 'package:quizlet_frontend/topic/bloc/topic_bloc.dart';
import 'package:quizlet_frontend/topic/bloc/topic_event.dart';
import 'package:quizlet_frontend/topic/bloc/topic_state.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  void initState() {
    context.read<TopicListBloc>().add(TopicListLoading());
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
        if (state.isLoading || state.topics.isEmpty) {
          return _buildEmptyTodoBackground();
        }
        return ListView.builder(
          itemBuilder: _buildTopicItem,
          itemCount: state.topics.length,
        );
      },
    );
  }

  Widget _buildEmptyTodoBackground() {
    return AspectRatio(
        aspectRatio: 1,
        child: Image.asset('assets/images/img_empty_todo_list.jpg'));
  }

  Widget _buildTopicItem(BuildContext context, int index) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    BlocProvider.of<TopicListBloc>(context)
                        .state
                        .topics[index]
                        .name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('228 thuat ngu'),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            'https://vtv1.mediacdn.vn/zoom/640_400/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Peterlll',
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
                    image: NetworkImage(
                        'https://vtv1.mediacdn.vn/zoom/640_400/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'))),
          ),
        ],
      ),
    );
  }
}
