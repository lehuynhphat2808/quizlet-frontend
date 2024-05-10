import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0Web auth0;

  @override
  void initState() {
    super.initState();
    auth0 =
        Auth0Web('quizlet.jp.auth0.com', 'PXPoy9JnUzaRrdk5EK0jKTjL9uBhSHxH');

    auth0
        .onLoad(
          audience: 'http://localhost:8080',
        )
        .then((final credentials) => setState(() {
              _credentials = credentials;
              print('_credentials: ${_credentials?.toMap()}');
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_credentials == null)
          ElevatedButton(
              onPressed: () => auth0.loginWithRedirect(
                    redirectUrl: 'http://localhost:3000',
                  ),
              child: const Text("Log in"))
        else
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await auth0.logout(returnToUrl: 'http://localhost:3000');
                  },
                  child: const Text("Log out"))
            ],
          )
      ],
    );
  }
}
