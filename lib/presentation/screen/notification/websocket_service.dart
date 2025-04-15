// websocket_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  final RxList<String> messages = <String>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionStatus = 'Disconnected'.obs;

  String? _lastMessageRaw;

  // Initialize and connect automatically
  Future<WebSocketService> init() async {
    await connect();
    return this;
  }

  Future<void> connect() async {
    if (isConnecting.value) return;

    isConnecting.value = true;
    connectionStatus.value = 'Connecting...';

    final String? token = await SecureStorage.getSessionId();
    if (token == null) {
      print("❌ No access token found");
      connectionStatus.value = 'Authentication Error';
      isConnecting.value = false;
      return;
    } else {
      print(token);
    }
    final url =
        'ws://mq459llx-8000.inc1.devtunnels.ms/ws/notifications/?token=$token';

    try {
      final websocket = await WebSocket.connect(url);
      _channel = IOWebSocketChannel(websocket);
      isConnected.value = true;
      connectionStatus.value = 'Connected';
      print("✅ WebSocket connected successfully");

      _channel!.stream.listen(
        (message) {
          if (message == _lastMessageRaw) {
            // Duplicate, ignore
            return;
          }

          _lastMessageRaw = message;

          try {
            final data = jsonDecode(message);
            final formatted =
                "[${data['timestamp']}] ${data['type']}: ${data['message']}";
            messages.add(formatted);
            print("🔔 New message received: $formatted");
          } catch (e) {
            print("❌ JSON parse error: $e");
            messages.add("Raw: $message");
          }
        },
        onError: (error) {
          print("💥 WebSocket error: $error");
          connectionStatus.value = 'Error: $error';
          isConnected.value = false;
        },
        onDone: () {
          print("❌ WebSocket closed");
          connectionStatus.value = 'Disconnected';
          isConnected.value = false;
        },
      );
    } catch (e) {
      print("❌ WebSocket connection error: $e");
      connectionStatus.value = 'Connection Failed';
      isConnected.value = false;
    } finally {
      isConnecting.value = false;
    }
  }

  void send(String message) {
    if (!isConnected.value) {
      print("❌ Cannot send message: WebSocket not connected");
      return;
    }

    try {
      _channel?.sink.add(message);
      print("📤 Message sent: $message");
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  void clearMessages() {
    messages.clear();
    print("🧹 Cleared all messages");
  }

  void disconnect() {
    if (!isConnected.value) return;

    try {
      _channel?.sink.close();
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
      print("🔌 WebSocket disconnected");
    } catch (e) {
      print("❌ Error disconnecting: $e");
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
