import 'package:brandsinfo/network/api_constants.dart';
import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  final double size;
  final Color borderColor;
  final double imageScale; // New: Scale for image size inside the circle

  const CircularImageWidget({
    super.key,
    this.size = 100, // Default outer circle size
    this.borderColor = Colors.orange, // Default border color
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
        border: Border.all(color: borderColor, width: 5), // Orange border
      ),
      child: ClipOval(
        child: Padding(
          padding:
              EdgeInsets.all(size * (1 - imageScale) / 2), // Center small image
          child: Image.network(
            "${ApiConstants.imagesurl}/Brandsinfo-logo.png",
            fit: BoxFit.contain, // Ensures the image is smaller inside
          ),
        ),
      ),
    );
  }
}
