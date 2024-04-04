import 'package:animate_do/animate_do.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(
        'quizletfrontend.jp.auth0.com', 'AXvyRQgBFSYZvRf6Tfn1wIspH67KS8Am');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background_login.png'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInDown(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInDown(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInDown(
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: const Center(
                              child: Text(
                                "Welcome",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  fontSize: 60,
                                  fontFamily: 'Pacifico',
                                ),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: InkWell(
                            onTap: () async {
                              final credentials = await auth0
                                  .webAuthentication(scheme: "demo")
                                  .login();

                              setState(() {
                                _credentials = credentials;
                                print(_credentials!.user.sub);
                                print(_credentials!.idToken);
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(39, 158, 0, 1.0),
                                    Color.fromRGBO(70, 252, 3, 1.0),
                                  ])),
                              child: const Center(
                                child: ListTile(
                                  trailing: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Get Started",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
