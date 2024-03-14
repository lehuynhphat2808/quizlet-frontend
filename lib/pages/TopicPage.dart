import 'package:flutter/material.dart';

class TopicPage extends StatelessWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'French Verbs, French verbs',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('228 thuat ngu'),
                    ),
                    Padding(
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
      },
    );
  }
}
