import 'package:flutter/material.dart';
import 'package:quizlet_frontend/leading_board_page/leading_board_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';

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
        title: Text('Leading Board'),
        centerTitle: true,
      ),
      body: FutureBuilder<LeadingBoardModel>(
        future: ApiService.getLeadingBoard(widget.id),
        builder:
            (BuildContext context, AsyncSnapshot<LeadingBoardModel> snapshot) {
          if (snapshot.hasData) {
            LeadingBoardModel leadingBoardModel = snapshot.data!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background_leading_board.jpg'),
                      fit: BoxFit.cover)),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
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
                                      placeholder: const AssetImage(
                                          'assets/images/default_profile.png'),
                                      image: NetworkImage(leadingBoardModel
                                          .users[index].avatar)),
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
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
              height: 200,
              width: 200,
              color: Colors.red,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
