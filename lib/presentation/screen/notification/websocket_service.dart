import 'dart:io';
import 'dart:convert';
import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;

  final RxList<String> messages = <String>[].obs;

  Future<void> connect() async {
    final String? sessionId = await SecureStorage.getSessionId();

    final websocket = await WebSocket.connect(
      ApiConstants.notificationws,
      headers: {
        'Cookie': 'sessionid=$sessionId',
      },
    );

    _channel = IOWebSocketChannel(websocket);

    _channel!.stream.listen(
      (message) {
        print("Received: $message");
        messages.add(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
