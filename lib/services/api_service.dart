import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:quizlet_frontend/folder/add_folder_model.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/helper/helper.dart';
import 'package:quizlet_frontend/leading_board_page/leading_board_model.dart';
import 'package:quizlet_frontend/services/auth0_service.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/user/user_model.dart';
import 'package:quizlet_frontend/utilities/error_response.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';
import 'package:http/http.dart' as http;
import 'package:quizlet_frontend/word/word_model.dart';

class ApiService {
  static late UserModel userModel;
  static String baseUrl = 'http://10.0.2.2:8080/api/v1/';
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${Auth0Service.credentials!.accessToken}",
      };

  static dynamic decodeData(Uint8List data) {
    return jsonDecode(utf8.decode(data));
  }

  static Future<PageResponse> getPageTopic() async {
    var res = await http.get(Uri.parse('${baseUrl}topics'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      if (kDebugMode) {
        print(response);
      }
      return PageResponse.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  static Future<PageResponse> getPageTopicPublic() async {
    var res = await http.get(Uri.parse('${baseUrl}topics/community'),
        headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      if (kDebugMode) {
        print(response);
      }
      return PageResponse.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  static Future<TopicModel> addTopic(TopicModel topicModel) async {
    var res = await http.post(Uri.parse('${baseUrl}topics'),
        headers: headers, body: jsonEncode(topicModel.toJson()));
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return TopicModel.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  static Future<WordModel> addWord(WordModel wordModel) async {
    print('addword: ${wordModel.toJson()}');
    var res = await http.post(Uri.parse('${baseUrl}words'),
        headers: headers, body: jsonEncode(wordModel.toJson()));
    print(wordModel.toJson());
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return WordModel.fromJson(response);
    } else {
      throw Exception("addWord fail ${res.statusCode}");
    }
  }

  static Future<TopicModel> getTopic(String id) async {
    print('APIGETTOPICID $id');
    var res =
        await http.get(Uri.parse('${baseUrl}topics/$id'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = decodeData(res.bodyBytes);
      print('response: $response');
      return TopicModel.fromJson(response);
    } else {
      throw Exception("getTopic fail ${res.statusCode}");
    }
  }

  static Future<void> deleteTopic(String topicId) async {
    var res = await http.delete(Uri.parse('${baseUrl}topics/$topicId'),
        headers: headers);
    if (res.statusCode != 200) {
      throw Exception("deleteTopic fail ${res.statusCode}");
    }
    if (kDebugMode) {
      print('Delete Topic: $topicId');
    }
  }

  static Future<void> updateTopic(TopicModel topicModel) async {
    print(
        'updateTopic topicModel.toJson(): ${jsonEncode(topicModel.toJson())}');
    var res = await http.put(Uri.parse('${baseUrl}topics/${topicModel.id}'),
        headers: headers, body: jsonEncode(topicModel.toJson()));
    if (res.statusCode != 200) {
      throw Exception("update topic fail ${res.statusCode}");
    }
  }

  static Future<void> updateWord(WordModel wordModel) async {
    print('Update word: ${wordModel.toJson()}');
    var res = await http.put(Uri.parse('${baseUrl}words/${wordModel.id}'),
        headers: headers, body: jsonEncode(wordModel.toJson()));
    if (res.statusCode != 200) {
      throw Exception("updateWord fail ${res.statusCode}");
    }
  }

  static Future<void> deleteWord(String wordId) async {
    var res = await http.delete(Uri.parse('${baseUrl}words/$wordId'),
        headers: headers);
    if (res.statusCode != 200) {
      throw Exception("deleteWord fail ${res.statusCode}");
    }
    if (kDebugMode) {
      print('Delete Topic: $wordId');
    }
  }

  static Future<LeadingBoardModel> getLeadingBoard(String id) async {
    var res = await http.get(Uri.parse('${baseUrl}leaderboard/$id'),
        headers: headers);
    print('getLeadingBoard: ${res.statusCode}');

    if (res.statusCode == 200) {
      if (res.body.isEmpty) {
        throw Exception("getTopic fail: res.body.isEmpty");
      }
      Map<String, dynamic> response = jsonDecode(res.body);
      print('getLeadingBoard2: ${response}');
      return LeadingBoardModel.fromJson(response);
    } else {
      throw Exception("getTopic fail ${res.statusCode}");
    }
  }

  static Future<void> addScore(String topicId, int score) async {
    var res = await http.post(Uri.parse('${baseUrl}user-scores'),
        headers: headers,
        body: jsonEncode({'topicId': topicId, 'score': score}));
    if (res.statusCode != 200) {
      throw Exception("addWord fail ${res.statusCode}");
    }
  }

  static Future<void> updatePassword(
      String oldPassword, String newPassword) async {
    var res = await http.put(Uri.parse('${baseUrl}users/password'),
        headers: headers,
        body: jsonEncode(
            {'oldPassword': oldPassword, 'newPassword': newPassword}));
    if (res.statusCode == 403) {
      throw Exception("Wrong password");
    }
    if (res.statusCode != 200) {
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(jsonDecode(res.body));
      throw Exception("Update Password fail: ${errorResponse.message}");
    }
  }

  static Future<void> getProfile() async {
    var res =
        await http.get(Uri.parse('${baseUrl}users/profile'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      print(response);
      userModel = UserModel.fromJson(response);
    } else {
      throw Exception("getTopic fail ${res.statusCode}");
    }
  }

  static Future<void> addFolder(AddFolderModel addFolderModel) async {
    var res = await http.post(Uri.parse('${baseUrl}folders'),
        headers: headers, body: jsonEncode(addFolderModel.toJson()));
    if (res.statusCode != 200) {
      throw Exception("addFolder fail ${res.statusCode}");
    }
  }

  static Future<PageResponse> getPageFolder() async {
    var res = await http.get(Uri.parse('${baseUrl}folders'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = decodeData(res.bodyBytes);
      if (kDebugMode) {
        print(response);
      }
      return PageResponse.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  static Future<FolderModel> getFolder(String id) async {
    print('getFolder');
    var res =
        await http.get(Uri.parse('${baseUrl}folders/$id'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = decodeData(res.bodyBytes);
      try {
        print('response: $response');
        print('response: ${FolderModel.fromJson(response)}');
      } catch (e) {
        print(e);
      }
      return FolderModel.fromJson(response);
    } else {
      throw Exception("getFolder fail ${res.statusCode}");
    }
  }

  static Future<void> deleteFolder(String folderId) async {
    var res = await http.delete(Uri.parse('${baseUrl}folders/$folderId'),
        headers: headers);
    if (res.statusCode != 200) {
      throw Exception("deleteFolder fail ${res.statusCode}");
    }
  }

  static Future<void> updateFolder(
      String id, AddFolderModel addFolderModel) async {
    var res = await http.put(Uri.parse('${baseUrl}folders/${id}'),
        headers: headers, body: jsonEncode(addFolderModel.toJson()));
    if (res.statusCode != 200) {
      throw Exception("updateFolder fail ${res.statusCode}");
    }
  }
}
