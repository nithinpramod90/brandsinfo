import 'package:brandsinfo/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';

class SpecificSectorController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;

  /// ✅ **Fix: Use `RxList<String>` instead of `RxSet<String>`**
  var selectedCategories = <String>[].obs;

  void fetchCategories(String cid, String bid) async {
    try {
      isLoading(true);
      final response = await ApiService().get('/users/get_descats/?gcid=$cid');
      if (response is List) {
        categories.assignAll(response.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      CommonSnackbar.show(
          title: "Error", message: "Failed to load categories", isError: true);
    } finally {
      isLoading(false);
    }
  }

  void toggleCategorySelection(String categoryId) {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }
    selectedCategories.refresh(); // ✅ Force UI to update!
  }

  /// ✅ **Fix: Ensure API receives selected categories as a List**
  Future<void> addsecctor(String bid) async {
    if (selectedCategories.isEmpty) {
      CommonSnackbar.show(
          title: "Selection Error",
          message: "Please select at least one category",
          isError: true);
      return;
    }

    try {
      Loader.show();
      final response = await ApiService().post(
        '/users/add_descats/',
        {
          "bid": bid,
          "dcid": selectedCategories, // ✅ Now correctly sends a list
        },
        useSession: true,
      );
      Loader.hide();

      if (response.statusCode == 200) {
        Get.offAll(() => HomeScreen());
      } else {
        CommonSnackbar.show(
            title: "Error",
            message: "Unexpected Error occurred",
            isError: true);
      }
    } catch (e) {
      Loader.hide();
      CommonSnackbar.show(
          title: "Error", message: "Unexpected Error occurred", isError: true);
    }
  }
}
