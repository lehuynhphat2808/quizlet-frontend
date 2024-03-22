import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_frontend/utilities/PageResponse.dart';
import 'package:quizlet_frontend/Topic/TopicProvider.dart';
import 'package:quizlet_frontend/services/ApiService.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<TopicProvider>(context, listen: false).getTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<TopicProvider>(
          builder: (context, provider, _) {
            // Lấy dữ liệu từ provider
            final topics = provider.topicModels;
            print(topics);
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (_, index) {
                return Text(topics[index].name);
              },
            );
          },
        ),
      ),
    );
  }
}
