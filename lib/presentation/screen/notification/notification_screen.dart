import 'package:brandsinfo/presentation/screen/notification/widgets/no_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotificationWidget(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'websocket_service.dart';

// class WebSocketScreen extends StatelessWidget {
//   final WebSocketService _wsService = Get.put(WebSocketService());

//   WebSocketScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     _wsService.connect(); // Connect on build. Or use controller lifecycle.

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WebSocket Demo'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() => ListView.builder(
//                   itemCount: _wsService.messages.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(_wsService.messages[index]),
//                     );
//                   },
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 _wsService.send("Hello from Flutter");
//               },
//               child: const Text("Send Dummy Message"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
