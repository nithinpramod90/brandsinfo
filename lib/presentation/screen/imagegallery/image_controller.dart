import 'dart:io';
import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageGalleryController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  RxList<Map<String, dynamic>> images = <Map<String, dynamic>>[].obs;
  RxBool isUploading = false.obs;
  final String bid;

  // Constructor to receive bid
  ImageGalleryController({required this.bid});

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  /// Fetch images from the API
  Future<void> fetchImages() async {
    try {
      final response = await _apiService.get("/users/buisness_pics/?bid=$bid");
      if (response is List) {
        images.value = response.cast<Map<String, dynamic>>();
      } else {
        Get.snackbar("Error", "Invalid API response format");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching images: $e");
    }
  }

  /// Upload selected images to the server
  Future<void> uploadImages(List<File> selectedFiles) async {
    if (selectedFiles.isEmpty) return;

    try {
      isUploading.value = true;
      final response = await _apiService.post(
        "/users/buisness_pics/",
        {'images[]': selectedFiles, 'buisness': bid},
        useSession: true,
        isMultipart: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Images uploaded successfully");

        fetchImages(); // Refresh gallery
      } else {
        Get.snackbar("Error", "Failed to upload images");
      }
    } catch (e) {
      Loader.hide();

      Get.snackbar("Error", "Error uploading images");
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete an image from the server
  Future<void> deleteImage(String imageId) async {
    try {
      final response = await _apiService.delete('/users/delete_pic/$imageId/');
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Success", "Image deleted successfully");
        fetchImages(); // Refresh gallery after deletion
      } else {
        Get.snackbar("Error", "Failed to delete image");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting image: $e");
    }
  }
}
