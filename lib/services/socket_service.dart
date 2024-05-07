import 'dart:async';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'auth0_service.dart';

class StompClientService {
  late StompClient _stompClient;

  String get token => Auth0Service.credentials!.accessToken;
  final void Function(StompFrame) _onReceiveMessage;
  String topicId;

  StompClientService(this.topicId, this._onReceiveMessage) {
    _stompClient = StompClient(
        config: StompConfig(
      url: 'ws://10.0.2.2:8080/stomp',
      onConnect: _onConnect,
      beforeConnect: _beforeConnect,
      onWebSocketError: _onWebSocketError,
      stompConnectHeaders: {'Authorization': 'Bearer $token'},
      webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
    ));
  }

  void connect() {
    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print('Stomp connected');
    _subscribeToTopic();
  }

  Future<void> _beforeConnect() async {
    print('Waiting to connect...');
    await Future.delayed(const Duration(seconds: 1));
    print('Connecting...');
  }

  void _onWebSocketError(dynamic error) {
    print('WebSocket error: $error');
  }

  void _subscribeToTopic() {
    _stompClient.subscribe(
      destination: '/live-updates/leaderboard/$topicId',
      callback: _onReceiveMessage,
    );
  }
}
