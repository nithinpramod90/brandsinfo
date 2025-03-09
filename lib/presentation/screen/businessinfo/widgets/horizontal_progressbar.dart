import 'package:flutter/material.dart';

class HorizontalProgressBar extends StatelessWidget {
  final double progress; // Progress value between 0.0 and 1.0

  const HorizontalProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth, // Take full available width
          height: 6.0, // Height of the progress bar
          decoration: BoxDecoration(
            color: Colors.grey[300], // Grey background
            borderRadius: BorderRadius.circular(0.0), // Rounded corners
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * progress, // Calculate filled width
              height: 6.0, // Match parent height
              decoration: BoxDecoration(
                color: Color(0xffFF750C), // Orange progress fill
                borderRadius: BorderRadius.circular(0.0), // Rounded corners
              ),
            ),
          ),
        );
      },
    );
  }
}
