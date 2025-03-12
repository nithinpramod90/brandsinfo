import 'dart:io';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/imagegallery/image_gallery.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:flutter/material.dart';

class ImageGalleryController extends GetxController {
  RxList<Map<String, dynamic>> uploadedImages = <Map<String, dynamic>>[].obs;

  void addUploadedImages(List<Map<String, dynamic>> newImages) {
    // final imageGallery = Get.find<ImageGallery>();
    uploadedImages.addAll(newImages);
    update(); // Notify listeners about changes
  }

  // API service instance
  final ApiService _apiService = ApiService();

  // Observable variables
  RxList<File> selectedImages = <File>[].obs;
  RxBool isUploading = false.obs;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to pick images from gallery
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        // Convert XFile to File
        final selectedFiles = images.map((xFile) => File(xFile.path)).toList();
        selectedImages.value = selectedFiles; // Replace existing selection

        // Show upload dialog after selecting images
        _showUploadDialog();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to take a photo using camera
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        selectedImages.value = [File(photo.path)]; // Replace existing selection

        // Show upload dialog after taking photo
        _showUploadDialog();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error taking photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to show upload dialog with fixed layout
  void _showUploadDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Upload Images'),
        content: Obx(() => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      '${selectedImages.length} ${selectedImages.length == 1 ? 'image' : 'images'} selected'),
                  const SizedBox(height: 16),
                  if (selectedImages.isNotEmpty && selectedImages.length <= 3)
                    SizedBox(
                      height: 100,
                      width: double.maxFinite, // Provide width constraint
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            height: 100, // Explicitly set height
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedImages[index],
                                fit: BoxFit.cover,
                                width: 100, // Explicit dimensions
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (isUploading.value)
                    Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Uploading...'),
                      ],
                    ),
                ],
              ),
            )),
        actions: [
          TextButton(
            onPressed: () {
              if (!isUploading.value) {
                selectedImages.clear();
                Get.back();
              }
            },
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isUploading.value ? null : uploadImages,
                child: const Text('Upload'),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      isUploading.value = true;
      final controller = Get.find<BusinessinfoController>();
      Map<String, dynamic> requestData = {
        'images[]': selectedImages,
        'buisness': controller.bid.value,
      };

      final response = await _apiService.post(
        "/users/buisness_pics/",
        requestData,
        useSession: true,
        isMultipart: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Images uploaded successfully');
        selectedImages.clear();

        if (response.data != null && response.data is List) {
          final newImages = List<Map<String, dynamic>>.from(response.data);
          Get.find<ImageGalleryController>().addUploadedImages(newImages);
        }
      } else {
        Get.back();
        Get.snackbar('Error', 'Failed to upload images');
      }
    } catch (e) {
      Get.back();
      print(e);
      Get.snackbar('Error', 'Error uploading images: $e');
    } finally {
      isUploading.value = false;
    }
  }

  // Function to delete an image
  Future<void> deleteImage(dynamic imageId) async {
    try {
      // Show confirmation dialog
      final shouldDelete = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Get.back(result: true),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (shouldDelete != true) return;

      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const SimpleDialog(
            title: Text('Deleting...'),
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Make the API call to delete the image
      final response = await _apiService.delete(
        'users/delete_pic/$imageId/', // Your delete endpoint
      );

      // Close loading dialog
      Get.back();

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 204) {
        uploadedImages.removeWhere((item) => item['id'].toString() == imageId);
        Get.find<ImageGallery>()
            .images
            .removeWhere((item) => item['id'].toString() == imageId);
        update(); // Ensure UI reflects the deletion
        Get.snackbar(
          'Success',
          'Image deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading dialog if it's showing
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Error deleting image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
