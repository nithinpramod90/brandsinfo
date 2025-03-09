import 'package:brandsinfo/widgets/imagepicker/image_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePickerWidget extends StatelessWidget {
  final ImagePickerController controller = Get.put(ImagePickerController());

  ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            onPressed: controller.selectedImages.length < 4
                ? controller.pickImage
                : () => controller.showImagePreview(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.selectedImages.isEmpty
                      ? CupertinoIcons.cloud_upload
                      : CupertinoIcons.photo,
                  color: Color(0xffFF750C),
                  size: 24,
                ),
                SizedBox(width: 5),
                Text(
                  controller.selectedImages.isEmpty
                      ? "Add Images"
                      : "Images (${controller.selectedImages.length}/4)",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        // Obx(
        //   () => controller.selectedImages.isNotEmpty
        //       ? IconButton(
        //           icon: Icon(Icons.delete, color: Colors.red),
        //           onPressed: controller.clearImages,
        //         )
        //       : SizedBox.shrink(),
        // ),
      ],
    );
  }
}
