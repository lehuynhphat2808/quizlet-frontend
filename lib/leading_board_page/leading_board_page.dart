import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizlet_frontend/leading_board_page/leading_board_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/services/socket_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class LeadingBoardPage extends StatefulWidget {
  final String id;
  const LeadingBoardPage({super.key, required this.id});

  @override
  State<LeadingBoardPage> createState() => _LeadingBoardPageState();
}

class _LeadingBoardPageState extends State<LeadingBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Leading Board',
          style: TextStyle(fontFamily: 'Pacifico'),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<LeadingBoardModel>(
        future: ApiService.getLeadingBoard(widget.id),
        builder:
            (BuildContext context, AsyncSnapshot<LeadingBoardModel> snapshot) {
          if (snapshot.hasData) {
            LeadingBoardModel leadingBoardModel = snapshot.data!;
            return MyBoard(leadingBoardModel: leadingBoardModel);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background_leading_board.jpg'),
                      fit: BoxFit.cover)),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyBoard extends StatefulWidget {
  final LeadingBoardModel leadingBoardModel;
  const MyBoard({super.key, required this.leadingBoardModel});

  @override
  State<MyBoard> createState() => _MyBoardState();
}

class _MyBoardState extends State<MyBoard> {
  late LeadingBoardModel leadingBoardModel = widget.leadingBoardModel;
  void _onReceiveMessage(StompFrame frame) {
    print('frame: ${frame.body}');
    // handling message
    if (frame.body != null) {
      setState(() {
        leadingBoardModel = LeadingBoardModel.fromJson(jsonDecode(frame.body!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    StompClientService(leadingBoardModel.topicId, _onReceiveMessage).connect();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background_leading_board.jpg'),
              fit: BoxFit.cover)),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/images/default_profile.png'),
                              image: NetworkImage(
                                  leadingBoardModel.users[index].avatar)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      leadingBoardModel.users[index].nickname,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '${leadingBoardModel.users[index].score} Pts',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: leadingBoardModel.users.length,
      ),
    );
  }
}
