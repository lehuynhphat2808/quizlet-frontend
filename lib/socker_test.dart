import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

const topicId = "42f7a67c-0ad6-4aaa-8947-779417e5565b";
late List<dynamic> data;
void onConnect(StompFrame frame) {
  print('on conect');
  stompClient.subscribe(
    destination: '/live-updates/leaderboard/${topicId}',
    callback: (frame) {
      print('frame: ${frame.headers}');
      Map<String, dynamic>? result = json.decode(frame.body!);
      print('xxxxxxxxxxxxx');
      print(result);
    },
  );
}

const token =
    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkY0U25PSlJsZUc2OVFkUHZCNzhocCJ9.eyJpc3MiOiJodHRwczovL3F1aXpsZXQuanAuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTE0ODAxNDYxMDIxMTE0Mjk5MDY4IiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImh0dHBzOi8vcXVpemxldC5qcC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzE1MDg5NDQ5LCJleHAiOjE3MTUxNzU4NDksInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgb2ZmbGluZV9hY2Nlc3MiLCJhenAiOiJQWFBveTlKblV6YVJyZGs1RUswaktUakw5dUJoU0h4SCIsInBlcm1pc3Npb25zIjpbXX0.W-_4c4uYajWwUPn_gD3QGaWW0DMyOpurIEEZAT1A5vAKX2MFQ4FycwtU-YmmULjMbCzktMlGfEQpZjHZofJ9IliN2J31gPCkz_eWzrhjzQzgG7t4efdV4UR-tZANcWWgcx9Pw71SMlCh58YeMN1upLnWMZvVtspXL42dVJWlzDu22wKx9gMe9wlA5oo6r4L90CDX8Ic_DVc3D1K_G3LYpxbN5_77bKyPiupaBe6YJcv3CUWp6zMx_D33YJTctY26ZcrWr59V8HlG4YQ8-IzVG9ww164abrcX29-wZIbol8RgUhx_tBDI6VQUVGVG8A5Ms1xH6jvJJNw2PsWaO_jWHA';
final stompClient = StompClient(
  config: StompConfig(
    url: 'ws://localhost:8080/stomp',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(const Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) => print(error.toString()),
    stompConnectHeaders: {'Authorization': 'Bearer $token'},
    webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
  ),
);

void main() {
  stompClient.activate();
}
