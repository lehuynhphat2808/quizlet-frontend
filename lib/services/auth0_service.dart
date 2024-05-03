import 'package:auth0_flutter/auth0_flutter.dart';

class Auth0Service {
  static Auth0? _auth0;
  static getAutho0() {
    _auth0 ??=
        Auth0('quizlet.jp.auth0.com', 'PXPoy9JnUzaRrdk5EK0jKTjL9uBhSHxH');
    return _auth0;
  }

  static Credentials? credentials;

  static Future<void> login() async {
    await _auth0!
        .webAuthentication(scheme: "demo")
        .login(audience: "http://localhost:8080");
    credentials = await _auth0!.credentialsManager.credentials();
  }

  static Future<void> logout() async {
    await _auth0!.webAuthentication(scheme: "demo").logout();

    _auth0 = null;
    credentials = null;
  }
}
