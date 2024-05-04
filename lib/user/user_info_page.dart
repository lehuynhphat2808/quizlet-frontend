import 'package:flutter/material.dart';
import 'package:quizlet_frontend/services/api_service.dart';

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
                      _buildPasswordWidget(
                          !Auth0Service.credentials!.user.sub
                              .contains('google'),
                          context),
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
                        _logout(context);
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

  Future<void> _logout(BuildContext context) async {
    await Auth0Service.logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.loginPage, (route) => false);
    }
  }

  Widget _buildPasswordWidget(bool enable, BuildContext context) {
    return enable
        ? GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text('Change Password'),
                    children: [UpdatePasswordForm()],
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: const ListTile(
                title: Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(8.0),
            child: const ListTile(
              title: Text(
                'Password',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.grey,
              ),
            ),
          );
  }
}

class UpdatePasswordForm extends StatefulWidget {
  const UpdatePasswordForm({super.key});

  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? newPassword;
  String? renewPassword;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Password'),
            // TextFormField(
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //
            //     return null;
            //   },
            // ),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),

            const Text('New Password'),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (newPassword != renewPassword) {
                  return 'New password now match with re new password';
                }

                return null;
              },
              onSaved: (newValue) {
                newPassword = newValue;
              },
            ),
            const Text('Re New Password'),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (newPassword != renewPassword) {
                  return 'New password now match with re new password';
                }
                return null;
              },
              onSaved: (newValue) {
                renewPassword = newValue;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ApiService.updatePassword(newPassword!);
                    } catch (e) {
                      setState(() {
                        error = e.toString();
                      });
                    }
                    if (error == '') {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Update password successfully')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
