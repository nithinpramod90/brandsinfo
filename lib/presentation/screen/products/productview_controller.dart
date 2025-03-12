import 'package:get/get.dart';
import 'package:brandsinfo/network/api_service.dart';

class ProductViewController extends GetxController {
  final ApiService _apiService = ApiService();
  RxList<dynamic> products = <dynamic>[].obs;
  RxBool isLoading = true.obs;
  RxString error = ''.obs;

  // Function to fetch products for a specific brand ID
  Future<void> fetchProducts(String bid) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Make API call using the provided URL pattern
      final response = await _apiService.get('/users/addproduct/?bid=$bid');

      // Based on your API response, the data is directly an array
      if (response != null) {
        products.value = response;
      } else {
        products.value = [];
      }
    } catch (e) {
      error.value = 'Failed to load products: $e';
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Function to delete a product - Using dynamic type for ID
  Future<void> deleteProduct(dynamic productId) async {
    try {
      // Make API call to delete product
      await _apiService.delete('/users/deleteproduct/$productId/');

      // Remove the product from the list after successful deletion
      products.removeWhere((product) => product['id'] == productId);
    } catch (e) {
      error.value = 'Failed to delete product: $e';
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }
}
