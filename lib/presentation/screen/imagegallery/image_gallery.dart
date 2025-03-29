import 'dart:io';
import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/imagegallery/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageGallery extends StatelessWidget {
  final String bid;
  ImageGallery({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    final ImageGalleryController controller =
        Get.put(ImageGalleryController(bid: bid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                File file = File(pickedFile.path);
                controller.uploadImages([file]);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.images.isEmpty) {
          return const Center(child: Text("No images available"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: controller.images.length,
          itemBuilder: (context, index) {
            final imageData = controller.images[index];
            return GestureDetector(
              onTap: () => _showImagePreview(context, imageData),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "${ApiConstants.apiurl}${imageData['image']}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showImagePreview(BuildContext context, Map<String, dynamic> imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                "${ApiConstants.apiurl}${imageData['image']}",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Delete"),
              onPressed: () {
                Navigator.pop(context);
                Get.find<ImageGalleryController>()
                    .deleteImage(imageData['id'].toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}
