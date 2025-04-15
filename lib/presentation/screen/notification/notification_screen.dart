import 'package:brandsinfo/presentation/screen/notification/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final WebSocketService wsService = WebSocketService();
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Connect if not already connected
    if (!wsService.isConnected.value && !wsService.isConnecting.value) {
      wsService.connect();
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    wsService.send(messageController.text);
    messageController.clear();
  }

  void reconnect() {
    wsService.disconnect();
    wsService.connect();
  }

  void clearMessages() {
    wsService.clearMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(() {
            final color = controller.wsService.isConnected.value
                ? Colors.green
                : Colors.red;

            return Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.wsService.connectionStatus.value,
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            );
          }),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Reconnect'),
                onTap: controller.reconnect,
              ),
              PopupMenuItem(
                child: const Text('Clear Messages'),
                onTap: controller.clearMessages,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = controller.wsService.messages;

              if (messages.isEmpty) {
                return const Center(
                  child: Text('No notifications yet'),
                );
              }

              return ListView.builder(
                itemCount: messages.length,
                reverse: true, // Show newest messages at the bottom
                itemBuilder: (context, index) {
                  // Reverse the index to show newest at the bottom
                  final reversedIndex = messages.length - 1 - index;
                  final message = messages[reversedIndex];

                  // Extract notification type for styling if possible
                  String? type;
                  try {
                    // Assuming format like "[time] TYPE: message"
                    final parts = message.split(':');
                    if (parts.length > 1) {
                      final typeParts = parts[0].split(']');
                      if (typeParts.length > 1) {
                        type = typeParts[1].trim();
                      }
                    }
                  } catch (_) {
                    type = null;
                  }

                  Color bubbleColor;
                  switch (type) {
                    case 'ERROR':
                      bubbleColor = Colors.red.shade100;
                      break;
                    case 'WARNING':
                      bubbleColor = const Color.fromARGB(255, 82, 81, 81);
                      break;
                    case 'INFO':
                      bubbleColor = const Color.fromARGB(255, 76, 76, 77);
                      break;
                    default:
                      bubbleColor = const Color.fromARGB(255, 77, 77, 77);
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: const InputDecoration(
                      hintText: 'Send a message',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
