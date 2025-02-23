import 'package:brandsinfo/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:brandsinfo/presentation/screen/login/login_screen.dart';
import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:get/get.dart';
import 'package:brandsinfo/network/api_service.dart';

class SplashController extends GetxController {
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _refreshSession();
  }

  Future<void> _refreshSession() async {
    String? refreshToken = await SecureStorage.getRefreshToken();
    if (refreshToken == null) {
      _navigateToLogin();
      return;
    }
    try {
      final response = await _apiService.post('/api/token/refresh/', {
        'refresh': refreshToken,
      });

      if (response.statusCode == 200) {
        String sessionId = response.data['access']; // Ensure correct key
        SecureStorage.saveSession(sessionId);
        _navigateToDashboard();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      print("Error refreshing session: $e");
      _navigateToLogin();
    }
  }

  void _navigateToDashboard() {
    Get.off(() => HomeScreen());
  }

  void _navigateToLogin() {
    Get.off(() => LoginScreen());
  }
}
