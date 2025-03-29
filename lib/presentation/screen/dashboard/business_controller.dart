import 'package:brandsinfo/model/business_model.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:get/get.dart';

class BusinessController extends GetxController {
  var isLoading = true.obs;
  var businessResponse = Rxn<BusinessResponse>();

  @override
  void onInit() {
    fetchBusinesses();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBusinesses(); // Refresh data when returning to the screen
  }

  Future<void> fetchBusinesses() async {
    try {
      isLoading(true);
      var response = await ApiService().get("/users/buisnesses/");
      businessResponse.value = BusinessResponse.fromJson(response);
    } catch (e) {
      print("Error fetching businesses: $e");
    } finally {
      isLoading(false);
    }
  }

  void reload() {
    fetchBusinesses();
  }
}
