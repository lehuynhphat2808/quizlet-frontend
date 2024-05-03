import 'package:flutter/material.dart';
import 'package:quizlet_frontend/services/auth0_service.dart';
import 'package:quizlet_frontend/user/user_info_page.dart';

class UserSettingPage extends StatelessWidget {
  const UserSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                Auth0Service.credentials!.user.pictureUrl.toString()),
          ),
          Text(
            '${Auth0Service.credentials!.user.nickname}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {},
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfoPage(),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      'Your Setting',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    leading: Image.asset('assets/images/user_setting.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
