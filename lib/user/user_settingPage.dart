import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/user/user_info_page.dart';
import 'package:quizlet_frontend/utilities/pick_upload_image.dart';

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({Key? key}) : super(key: key);

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  Language _selectedDialogLanguage =
      Language.fromIsoCode(ApiService.userModel.languageCode ?? 'vi');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? image = await pickImage();
              if (image != null) {
                var extension = image.files.first.extension;
                String url = await ApiService.uploadImage(
                    extension!, image.files.first.bytes!);
                await ApiService.updateProfile(avatar: url);
                await ApiService.getProfile();
                setState(() {});
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(ApiService.userModel.avatar),
            ),
          ),
          Text(
            ApiService.userModel.nickname,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfoPage(),
                ),
              );
              if (res != null && res) {
                setState(() {});
              }
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
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _openLanguagePickerDialog,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    _selectedDialogLanguage.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.language),
                  leading: Image.asset('assets/images/languages_icon.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: LanguagePickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: const Text('Select your language'),
                onValuePicked: (Language language) async {
                  setState(() {
                    _selectedDialogLanguage = language;
                    ApiService.userModel.languageCode =
                        _selectedDialogLanguage.isoCode;
                    print(_selectedDialogLanguage.name);
                    print(_selectedDialogLanguage.isoCode);
                  });
                  await ApiService.updateProfile(
                      languageCode: _selectedDialogLanguage.isoCode);
                  await ApiService.getProfile();
                },
                itemBuilder: _buildDialogItem)),
      );
  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(language.name),
          SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})"))
        ],
      );
}
