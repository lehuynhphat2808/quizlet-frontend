import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quizlet_frontend/utilities/PageResponse.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _token =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkY0U25PSlJsZUc2OVFkUHZCNzhocCJ9.eyJpc3MiOiJodHRwczovL3F1aXpsZXQuanAuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTA4MDEyNjE5MzA2MzAyNTU4OTUyIiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImh0dHBzOi8vcXVpemxldC5qcC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzExMDg5MjA3LCJleHAiOjE3MTExNzU2MDcsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJhenAiOiJmSkI5Tk5BUmQ3bTlqdUxGR2JDYTdybHBXcGcwd3V1biIsInBlcm1pc3Npb25zIjpbXX0.WiPZt5vULN_6h6WjJW7oaxwj-BOXh6Tp1zF117yr2qQNJGMA1uaMoZMmhUHpKlB_jORndtD7vacmueKYP6SPDlkdZ7-r9V5UNDVzkgYDbNvW6u4dY7dUIXSKqZPJUfBhCsn5Rp4Eu6slxUDCcY43ImWN_-6imXZ9OsU9p7iQT3yDddoyg70rjoNhfnWudRAQWVL61EPSOGlykm7Vzi-_13IpYLMeGafOnyiHw7GMLhKGr-E-5W_V1vUhuw3xKCuUZ-24EgmfdDSrJ_1er-CWMIsEb9ujY2JUEriQkS6k1FTgSklCPadlI__RI7Iahmi4ttj7S0PB4YM5dgwspkX98g';
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };
  static Future<PageResponse> getPageTopic() async {
    var res = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/topics/community'),
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
}
