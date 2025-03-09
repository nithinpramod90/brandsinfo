import 'package:flutter/material.dart';

class BusinessDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const BusinessDetailAppBar({super.key});

  @override
  Size get preferredSize =>
      Size.fromHeight(120); // Adjusted height to match reference

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              bool isReversed = index.isOdd;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isReversed) buildImage(47),
                  buildImage(107),
                  SizedBox(height: 10), // Space in column
                  if (!isReversed) buildImage(47),
                ],
              );
            }),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        Color(0xFF1E1E1E).withOpacity(1),
                        Color(0xFF1E1E1E).withOpacity(0.7),
                        Color(0xFF1E1E1E).withOpacity(0.4),
                      ] // Dark mode gradient
                    : [
                        Colors.white.withOpacity(1),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0),
                      ], // Light mode gradient
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImage(double height) {
    return Container(
      height: height,
      width: 90, // Adjusted width to match reference
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/images/images.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
