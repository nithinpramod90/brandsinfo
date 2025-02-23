import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loader {
  static void show() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // Prevent user from dismissing manually
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
