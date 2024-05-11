import 'package:animate_do/animate_do.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/services/auth0_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/router_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    print('initState');
    if (kIsWeb) {
      var auth0 = Auth0Service.getAutho0();

      auth0 = auth0 as Auth0Web;
      print('auth0: ${auth0}');
      auth0
          .onLoad(
              // audience: "http://localhost:8080",
              )
          .then(
            (credentials) => setState(
              () {
                print("credentials not empty ${credentials != null}");

                if (credentials != null) {
                  // authService.writeUserCredentialsToCache(credentials);
                  // context.go("/");
                  print('credentials: ${credentials.toMap()}');
                }
              },
            ),
          );
    }

    Future.microtask(() async {
      if (kIsWeb) {
        // var auth0 = Auth0Service.getAutho0();
        // Credentials? creds =
        //     await auth0.credentials(audience: "http://localhost:8080");
        // print('creds: ${creds?.toMap()}');
      } else {
        var auth0 = Auth0Service.getAutho0();
        print('init auth0');
        auth0 = auth0 as Auth0;
        if (await auth0.credentialsManager.hasValidCredentials()) {
          Auth0Service.credentials =
              await auth0.credentialsManager.credentials();
          print(
              'Auth0Service.credentials: ${Auth0Service.credentials!.user.sub}');
          print('token: ${Auth0Service.credentials!.accessToken}');
          await ApiService.getProfile();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.mainPage,
              (route) => false,
            );
          }
        }
      }
    });
    super.initState();
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
                              print('click login');
                              if (kIsWeb) {
                                var auth0Web = Auth0Service.getAutho0();
                                // await auth0Web
                                //     .onLoad(audience: "http://localhost:8080")
                                //     .then((final credentials) => setState(() {
                                //           Auth0Service.credentials =
                                //               credentials;
                                //         }));
                                // Set<String> scopes = {
                                //   'openid',
                                //   'profile',
                                //   'email',
                                // };
                                //
                                auth0Web.loginWithRedirect(
                                  redirectUrl: 'http://localhost:3000',

                                  // audience: 'http://localhost:8080',

                                  // scopes: {'offline_access'},
                                );
                                // auth0Web
                                //     .onLoad(
                                //       audience: "http://localhost:8080",
                                //     )
                                //     .then(
                                //       (credentials) => setState(
                                //         () {
                                //           print(
                                //               "credentials not empty0 ${credentials != null}");
                                //
                                //           if (credentials != null) {
                                //             // authService.writeUserCredentialsToCache(credentials);
                                //             // context.go("/");
                                //             print(
                                //                 'credentials2: ${credentials.toMap()}');
                                //           }
                                //         },
                                //       ),
                                //     );
                              } else {
                                await Auth0Service.login();
                                print('click login1');

                                await ApiService.getProfile();
                                print('click login2');

                                print(
                                    'profile: ${ApiService.userModel.toJson()}');
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.mainPage);
                                }
                              }
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
