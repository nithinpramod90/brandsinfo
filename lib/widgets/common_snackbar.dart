import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSnackbar {
  static void show({
    required String title,
    required String message,
    required bool isError,
    int durationInSeconds = 3,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red : Color(0xffFF750C),
      colorText: Colors.white,
      duration: Duration(seconds: durationInSeconds),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: Colors.white,
      ),
    );
  }
}
