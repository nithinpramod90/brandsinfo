import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_screen.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:get/get.dart';

class BusinessinfoController extends GetxController {
  var businessData = {}.obs;
  var businessInfo = {}.obs;
  var products = [].obs;
  var services = [].obs;
  var bid = ''.obs;
  var isLoading = false.obs; // 🔹 Track loading state

  // Set bid and navigate
  void setBidAndNavigate(String newBid) {
    // if (bid.value == newBid) return; // Prevent unnecessary reloads

    // 🔹 Clear all business-related data before setting new bid
    businessData.value = {};
    businessInfo.value = {};
    products.value = [];
    services.value = [];

    bid.value = newBid; // Store the new bid

    // Navigate to the business info screen
    Get.to(() => const BusinessinfoScreen());
  }

  Future<void> fetchBusinessData() async {
    try {
      isLoading.value = true; // Show loading indicator

      // 🔹 Clear previous data
      businessData.value = {};
      businessInfo.value = {};
      products.value = [];
      services.value = [];

      // Fetch new business data
      final response =
          await ApiService().get("/users/buisnesses/?bid=${bid.value}");

      // Update state with new data
      businessData.value = response;
      businessInfo.value = response['buisness'] ?? {};
      products.value = response['products'] ?? [];
      services.value = response['services'] ?? [];
    } catch (e) {
      CommonSnackbar.show(
          title: "Error", message: "Unknown Error Occurred", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
