import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  final double size;
  final double imageScale; // New: Scale for image size inside the circle

  const CircularImageWidget({
    super.key,
    this.size = 100, // Default outer circle size
    this.imageScale = 0.6, // Adjust image size inside the circle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xffFF750C), width: 5), // Orange border
      ),
      child: ClipOval(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.fill, // Ensures the image is smaller inside
        ),
      ),
    );
  }
}
