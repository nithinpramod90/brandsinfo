import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/imagegallery/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ImageGallery extends StatefulWidget {
  ImageGallery({
    super.key,
    required this.images,
  });
  List<dynamic> images;

  @override
  State<ImageGallery> createState() => ImageGalleryState();
  void addUploadedImages(List<Map<String, dynamic>> newImages) {
    images.addAll(newImages);
  }
}

class ImageGalleryState extends State<ImageGallery> {
  final ImageGalleryController controller = Get.put(ImageGalleryController());
  void updateImageGallery(List<Map<String, dynamic>> newImages) {
    setState(() {
      widget.images.addAll(newImages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () {
              controller.pickImages();
            },
          ),
        ],
      ),
      body: Obx(() {
        // Combine initial images with uploaded images
        final combinedImages = [...widget.images, ...controller.uploadedImages];

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: combinedImages.length,
          itemBuilder: (context, index) {
            final imageData = combinedImages[index];
            return GestureDetector(
              onTap: () => _showImagePreview(context, imageData),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "${ApiConstants.apiurl}${imageData['image']}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showImagePreview(BuildContext context, dynamic imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  "${ApiConstants.apiurl}${imageData['image']}",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.indigo.shade50 // Dark mode color
                              : Colors.black54, // Light mode color
                    ),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      'Delete',
                      style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black // Dark mode color
                            : Colors.indigo.shade50, // Light mode color,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context)
                          .pop(); // Close the image preview dialog first
                      await controller.deleteImage(imageData['id'].toString());
                      setState(() {
                        widget.images.removeWhere(
                            (item) => item['id'] == imageData['id']);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
