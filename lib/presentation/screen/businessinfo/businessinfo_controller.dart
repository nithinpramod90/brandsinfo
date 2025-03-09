// ignore_for_file: invalid_use_of_protected_member

import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_screen.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';

class BusinessinfoController extends GetxController {
  var businessData = {}.obs;
  var businessInfo = {}.obs;
  var products = [].obs;
  var services = [].obs;

  Future<void> fetchBusinessData(String bid) async {
    try {
      Loader.show();
      final response = await ApiService().get("/users/buisnesses/?bid=$bid");

      businessData.value = response;
      businessInfo.value = response['buisness'] ?? {};
      products.value = response['products'] ?? [];
      services.value = response['services'] ?? [];

      Loader.hide();

      // Ensure all required fields are passed
      Get.to(() => const BusinessinfoScreen(), arguments: {
        'business': businessInfo.value,
        'products': products.value,
        'services': services.value,
        'analytics': response['analytics'] ?? {},
      });
    } catch (e) {
      Loader.hide();
      CommonSnackbar.show(
          title: "Error", message: "Unknown Error Occurred", isError: true);
    }
  }
}
