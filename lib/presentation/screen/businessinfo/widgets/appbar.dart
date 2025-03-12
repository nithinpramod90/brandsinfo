import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/imagegallery/image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  BusinessDetailAppBar({
    super.key,
    required this.images,
  });
  List<dynamic> images;
  @override
  Size get preferredSize =>
      Size.fromHeight(120); // Adjusted height to match reference

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full width and height image
        Positioned.fill(
            child: images.isNotEmpty
                ? Image.network(
                    '${ApiConstants.apiurl}${images[0]['image']}',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/logo.png');
                    },
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.error,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // Dark mode color
                        : Colors.black, // Light,
                  )),
        Positioned.fill(
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
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              Get.off(() => ImageGallery(images: images));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
