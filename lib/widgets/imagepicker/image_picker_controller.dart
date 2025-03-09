import 'dart:io';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  var selectedImages = <File>[].obs; // Observable list
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<void> pickImage() async {
    if (selectedImages.length >= 4) {
      CommonSnackbar.show(
          isError: true,
          title: "Limit Reached",
          message: "You can upload up to 4 images only");

      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(File(pickedFile.path)); // Update observable list
    }
  }

  /// Remove a specific image
  void deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  /// Clear all images
  void clearImages() {
    selectedImages.clear();
  }

  void showImagePreview(BuildContext context) {
    if (selectedImages.isEmpty) return;

    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Image Preview"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 220, // Set a fixed height
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
              children: [
                Expanded(
                  // Wrap ListView in Expanded
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                deleteImage(index);
                                Navigator.pop(context); // Close dialog
                                showImagePreview(context); // Refresh dialog
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      );
    });
  }
}
