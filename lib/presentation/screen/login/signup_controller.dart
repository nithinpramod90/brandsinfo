import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:brandsinfo/presentation/screen/login/name_screen.dart';
import 'package:brandsinfo/presentation/screen/login/otp_screen.dart';
import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final ApiService apiService = ApiService();

  Future<void> signup(String phone, String verificationid) async {
    try {
      final response =
          await apiService.post('/users/signup1/', {'phone': phone});

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['exists'] == true) {
          Loader.hide();

          print("object");
          Get.to(() => OtpScreen(
                phno: phone,
                verificationId: verificationid,
              ));
        } else {
          Loader.hide();

          Get.to(() => NameScreen(
                phone: phone,
                verficationid: verificationid,
              ));
        }
      } else {
        print(response.statusCode);
        CommonSnackbar.show(
            isError: true,
            title: "Error",
            message: "Something Unexcepted Occured !");
      }
    } catch (e) {
      print(e);
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexcepted Occured !");
    } finally {
      Loader.hide();
    }
  }

  Future<void> resentotp(String phone) async {
    print("accesed resent");
    try {
      print("object");
      final response =
          await apiService.post('/users/resendotp/', {'phone': phone});
      print(response);
      if (response.statusCode == 200) {
        CommonSnackbar.show(
            isError: false, title: "Sucess", message: "Otp Resent Sucessfully");
      } else {
        print(response);
        CommonSnackbar.show(
            isError: true,
            title: "Error",
            message: "Something Unexcepted Occured !");
      }
    } catch (e) {
      print(e);
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexcepted Occured !");
    }
  }

  Future<void> verifyOtp(String phone, String otp, String idtoken) async {
    try {
      final response = await apiService.post('/users/verifyotp/', {
        'phone': phone,
        'otp': otp,
        'idToken': idtoken,
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
          CommonSnackbar.show(
              isError: true, title: "Error", message: "Invalid OTP");
        }
      } else {
        CommonSnackbar.show(
            isError: true, title: "Error", message: "Invalid OTP !");
      }
    } catch (e) {
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexpected Occured");
    }
  }

  Future<void> saveName(
      String phone, String name, String verificationid) async {
    try {
      final response = await apiService.post('/users/signup2/', {
        'phone': phone,
        'name': name,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "Name Saved") {
          Get.to(() => OtpScreen(
                phno: phone,
                verificationId: verificationid,
              ));
        } else {
          CommonSnackbar.show(
              isError: true,
              title: "Error",
              message: "Something Unexpected Occured");
        }
      }
    } catch (e) {
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexpected Occured");
    }
  }
}
