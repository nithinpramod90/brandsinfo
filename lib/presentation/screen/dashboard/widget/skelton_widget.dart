import 'package:flutter/material.dart';

class SkeletonLoaderWidget extends StatelessWidget {
  const SkeletonLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.grey.shade300,
    );
  }
}
