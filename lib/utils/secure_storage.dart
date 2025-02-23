import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveSession(String sessionId) async {
    await _storage.write(key: "sessionid", value: sessionId);
  }

  static Future<void> saverefresh(String refreshToken) async {
    await _storage.write(key: "refresh_token", value: refreshToken);
  }

  static Future<String?> getSessionId() async {
    return await _storage.read(key: "sessionid");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  static Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
