import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/add_product/add_product_screen.dart';
import 'package:get/get.dart';

class InformationController extends GetxController {
  final ApiService _apiService = ApiService();

  Future<void> sendinfo(
    String name,
    String pincode,
    String localityid,
    String district,
    String cityid,
    String state,
    String wpnum,
    String businessType,
  ) async {
    try {
      final response = await _apiService.post(
        '/users/buisnesses/',
        {
          'name': name,
          "pincode": pincode,
          "locality": localityid,
          "district": district,
          "city": cityid,
          "state": state,
          "whatsapp_number": wpnum,
          "buisness_type": businessType
        },
        useSession: true,
      );

      if (response.statusCode == 201) {
        if (businessType == "Product and Services" ||
            businessType == "Product") {
          Get.off(() => AddProductScreen());
        } else if (businessType == "Service") {
          print("Go to service page");
          // Get.off(() => AddProductScreen());
        }
      } else {
        print(response.data);
      }
    } catch (e) {
      print("Error refreshing session: $e");
    }
  }
}
