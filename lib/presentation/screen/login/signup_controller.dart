import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:brandsinfo/presentation/screen/login/name_screen.dart';
import 'package:brandsinfo/presentation/screen/login/otp_screen.dart';
import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final ApiService apiService = ApiService();

  Future<void> signup(String phone) async {
    try {
      final response =
          await apiService.post('/users/signup1/', {'phone': phone});

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['exists'] == true) {
          Get.to(() => OtpScreen(phno: phone));
        } else {
          Get.to(() => NameScreen(phone: phone));
        }
      } else {
        Get.snackbar("Error", "Unexpected response from server");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      final response = await apiService.post('/users/verifyotp/', {
        'phone': phone,
        'otp': otp,
      });

      print("Response: ${response.data}"); // Debugging line

      if (response.statusCode == 201 && response.data != null) {
        final responseData = response.data;
        if (responseData["message"] == "OTP Verified" &&
            responseData.containsKey('sessionid')) {
          await SecureStorage.saveSession(responseData['sessionid']);
          await SecureStorage.saverefresh(responseData['refresh_token']);

          Get.offAll(() => HomeScreen());
        } else {
          Get.snackbar("Error", "Invalid OTP or missing session data");
        }
      } else {
        Get.snackbar(
            "Error", "Unexpected response from server: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }
  }

  Future<void> saveName(String phone, String name) async {
    try {
      final response = await apiService.post('/users/signup2/', {
        'phone': phone,
        'name': name,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "Name Saved") {
          Get.to(() => OtpScreen(phno: phone));
        } else {
          Get.snackbar("Error", "Unexpected response from server");
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
