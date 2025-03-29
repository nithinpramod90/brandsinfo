// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';
// import 'package:brandsinfo/network/api_service.dart';
// import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';

// class ImageUploaderController extends GetxController {
//   final Rx<File?> selectedImage = Rx<File?>(null);

//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       selectedImage.value = File(image.path);
//     } else {
//       Get.snackbar("Error", "No image selected");
//     }
//   }

//   Future<void> uploadImage() async {
//     if (selectedImage.value == null) {
//       Get.snackbar("Error", "Please select an image first");
//       return;
//     }

//     try {
//       final controller = Get.find<BusinessinfoController>();
//       final String bid = controller.bid.value;

//       final response = await ApiService().patch(
//         "/users/buisnessesedit/$bid/",
//         {}, // Empty body since the image is in 'files'
//         files: {
//           'image': selectedImage.value!,
//         },
//       );

//       if (response != null) {
//         Get.snackbar("Success", "Image uploaded successfully");
//       } else {
//         Get.snackbar("Error", "Image upload failed");
//       }
//     } catch (e) {
//       print(e);
//       Get.snackbar("Error", "Failed to upload image");
//     }
//   }
// }
