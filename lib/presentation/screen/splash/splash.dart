import 'package:brandsinfo/presentation/screen/splash/splash_controller.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  // ignore: unused_field
  final SplashController _controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularImageWidget(
          size: Get.width / 3,
          imageScale: 0.5,
        ),
      ),
    );
  }
}
