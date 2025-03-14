import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/add_product/add_product_screen.dart';
import 'package:brandsinfo/presentation/screen/add_service/add_service_screen.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
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
      Loader.show();
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
      final int businessid = response.data["id"];
      if (response.statusCode == 201) {
        if (businessType == "Products & Services") {
          Get.off(() => AddProductScreen(
                nav: true,
                id: businessid,
                product: false,
              ));
        } else if (businessType == "Service") {
          Get.off(() => AddServiceScreen(
                business: businessid,
                service: false,
              ));
        } else if (businessType == "Product") {
          Get.off(() => AddProductScreen(
                nav: false,
                id: businessid,
                product: false,
              ));
        }
        Loader.hide();
      } else {
        CommonSnackbar.show(
          title: "error",
          message: "Unepected Error Occured",
          isError: true,
        );
        Loader.hide();
      }
    } catch (e) {
      CommonSnackbar.show(
        title: "error",
        message: "Unepected Error Occured",
        isError: true,
      );
      print("Error refreshing session: $e");
      Loader.hide();
    }
  }
}
