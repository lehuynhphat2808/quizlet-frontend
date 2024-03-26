import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quizlet_frontend/topic/topic_model.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';
import 'package:http/http.dart' as http;
import 'package:quizlet_frontend/word/word_model.dart';

class ApiService {
  static const String _token =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkY0U25PSlJsZUc2OVFkUHZCNzhocCJ9.eyJpc3MiOiJodHRwczovL3F1aXpsZXQuanAuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTE0ODAxNDYxMDIxMTE0Mjk5MDY4IiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImh0dHBzOi8vcXVpemxldC5qcC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzExNDI0NTk1LCJleHAiOjE3MTE1MTA5OTUsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhenAiOiJmSkI5Tk5BUmQ3bTlqdUxGR2JDYTdybHBXcGcwd3V1biIsInBlcm1pc3Npb25zIjpbXX0.L-2LrFinr_z6ce_vN3YjfSWCOKKjsEXHx9ZUiJgFBv2E7KX7D1yTN_IqtsJ-HcyJvDEy6C8l8_WMMz5HxzgbTY26kysLdzwc8PZ21KPsfHv5CdWxpABDrqcKYBY1dox3aHJqg4CYGPnZGh785KxMesPLRsn0Hm38Af2Aorh_lhONnhi_WUgQ5ZgboTMzMxQps0oMITHpT_RPXjNlFuYSlF9Pn6fKXZD_JIyz6IqucDAjUG9cyATbbSBKByND1kx7KyNkbTG0GwQAf-ESDhZ2aoksaE-vP27ldrchAv_onSPw_p9DKWGF3ya_M4UVPrpWLSvmtKgOKntTHnNMnCOCpw';
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
    var res = await http.post(Uri.parse('${baseUrl}words'),
        headers: headers, body: jsonEncode(wordModel.toJson()));
    print(wordModel.toJson());
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return WordModel.fromJson(response);
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }
}
