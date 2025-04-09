import 'dart:io';
import 'package:get/get.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:dio/dio.dart' as dio;

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
      print(error.value);
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Function to delete a product
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

  // Function to update only product basic information
  Future<void> updateProductBasicInfo(
      dynamic productId, Map<String, dynamic> productData) async {
    try {
      // Make API call to update product basic info
      await _apiService.patch('/users/edt_product/$productId/', productData);

      // Update the local product in the list
      final index =
          products.indexWhere((product) => product['id'] == productId);
      if (index != -1) {
        final updatedProduct = {
          ...products[index],
          'name': productData['name'],
          'price': productData['price'],
          'description': productData['description'],
        };
        products[index] = updatedProduct;
      }
    } catch (e) {
      error.value = 'Failed to update product: $e';
      throw Exception('Failed to update product: $e');
    }
  }

  // Function to delete a product image
  Future<void> deleteProductImage(dynamic imageId) async {
    try {
      // Make API call to delete the image using the provided endpoint
      await _apiService.delete('/users/dlt_product_img/$imageId/');
    } catch (e) {
      error.value = 'Failed to delete image: $e';
      throw Exception('Failed to delete image: $e');
    }
  }

  // Function to add product images
  Future<void> addProductImages(dynamic productId, List<File> images) async {
    try {
      // Create FormData for the image upload
      final dio.FormData formData = dio.FormData();

      // Add the product ID
      formData.fields.add(MapEntry('pid', productId.toString()));

      // Add all images - using "images[]" as the key to match your API expectations
      for (int i = 0; i < images.length; i++) {
        final fileName = images[i].path.split('/').last;
        formData.files.add(MapEntry(
            'images[]', // Changed from 'images' to 'images[]'
            await dio.MultipartFile.fromFile(
              images[i].path,
              filename: fileName,
            )));
      }

      // Make API call to add images
      await _apiService.postWithFormData('/users/add_product_img/', formData);
    } catch (e) {
      error.value = 'Failed to add images: $e';
      throw Exception('Failed to add images: $e');
    }
  }
}
