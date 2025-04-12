import 'package:brandsinfo/network/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initNotifications() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _messaging.getToken();
        await sendDeviceId(token!);

        print("✅ FCM Device Token: $token");

        // TODO: Store token or send to your backend
      } else {
        print("❌ Notification permission not granted");
      }
    } catch (e) {
      print("🔥 Error initializing notifications: $e");
    }
  }
}

Future<void> sendDeviceId(String id) async {
  try {
    final apiService = ApiService();

    final response = await apiService.post(
      "/users/add_deviceid/",
      {
        "device_id": id,
      },
      useSession: true,
    );

    // You can handle the response here if needed
    print("Device ID sent successfully: ${response.data}");
  } catch (e) {
    print("Failed to send device ID: $e");
  }
}
