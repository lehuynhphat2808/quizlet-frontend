import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth0_service.dart';
import '../utilities/router_manager.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromRGBO(179, 179, 179, 1.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(188, 185, 185, 1.0),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: ListTile(
                          title: const Text(
                            'Username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${Auth0Service.credentials!.user.nickname}',
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${Auth0Service.credentials!.user.email}',
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const ListTile(
                          title: Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Introduce',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromRGBO(179, 179, 179, 1.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(188, 185, 185, 1.0),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: const ListTile(
                          title: Text(
                            'Privacy',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: const ListTile(
                          title: Text(
                            'Terms of service',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: const ListTile(
                          title: Text(
                            'Open source license',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const ListTile(
                          title: Text(
                            'Support center',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        await Auth0Service.logout();
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.loginPage, (route) => false);
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Delete account',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
