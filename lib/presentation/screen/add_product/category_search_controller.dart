import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:get/get.dart';

class CategorySearchController extends GetxController {
  var categoryList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> searchCategories(String query) async {
    if (query.isEmpty) {
      categoryList.clear();
      return;
    }

    try {
      isLoading.value = true;
      final response = await ApiService().get("/users/searchpcats/?q=$query");

      if (response is List) {
        categoryList.value = List<Map<String, dynamic>>.from(response);
      } else {
        categoryList.clear();
        CommonSnackbar.show(
            isError: true,
            title: "Error",
            message: "Something Unexcepted Occured !");
      }
    } catch (e) {
      categoryList.clear();
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexcepted Occured !");
    } finally {
      isLoading.value = false;
    }
  }
}
