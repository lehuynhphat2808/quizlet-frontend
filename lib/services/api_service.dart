import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quizlet_frontend/helper/helper.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';
import 'package:http/http.dart' as http;
import 'package:quizlet_frontend/word/word_model.dart';

class ApiService {
  // static String _token = "";
  static String _token =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkY0U25PSlJsZUc2OVFkUHZCNzhocCJ9.eyJpc3MiOiJodHRwczovL3F1aXpsZXQuanAuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTE0ODAxNDYxMDIxMTE0Mjk5MDY4IiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImh0dHBzOi8vcXVpemxldC5qcC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzEyMzg1MjczLCJleHAiOjE3MTI0NzE2NzMsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhenAiOiJmSkI5Tk5BUmQ3bTlqdUxGR2JDYTdybHBXcGcwd3V1biIsInBlcm1pc3Npb25zIjpbXX0.X6SnnGABq1HsJKnm14s7zGbmZMU611n1HecluLPi7UevXmMEK0XK7JgG4kEoHHiFTG4R1IlG52pjjjr5sJqEqdGjbB1KFT6cJ4Ibz4_-6QPUMJHTeY--VENOvB16gdtufRVy8ogkyBrPz7Z-BtZxKJRi5ThJZcRYQJlifxxML_IBitHWNW3Ook6M3riSjzJyuozB5z2GO39atZNJ2-7ExndlppJHeK-F6aQdsSTdIfVXf0HqchHwoSZjtSa5JaTM35Vj4bFFDbWZdCb6mJL0yxrMayoWk9dU8eP11H9Zse75rW8rYhcU4rnuvuzW8_8Z9qbBvWWazPt5fep6Pc5tYw';
  static set token(newToken) {
    _token = newToken;
  }

  static get token => _token;

  static String baseUrl = 'http://10.0.2.2:8080/api/v1/';
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };
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
      Map<String, dynamic> response = jsonDecode(res.body);
      print(response);
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
}
