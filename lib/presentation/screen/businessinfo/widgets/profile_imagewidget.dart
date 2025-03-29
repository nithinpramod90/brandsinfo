import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/imagegallery/image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ignore: must_be_immutable
class ProfileImagewidget extends StatelessWidget {
  ProfileImagewidget(
      {super.key,
      required this.image,
      required this.businessname,
      required this.images,
      required this.businesstype,
      required this.bid});
  final String image;
  final String bid;
  List<dynamic> images;

  final String businessname;
  final String businesstype;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60, // Adjust size as needed
              height: 60, // Adjust size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xffFF750C), // Border color
                  width: 2, // Border width
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    '${ApiConstants.apiurl}$image'), // Replace with actual logo path
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  businessname,
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // color: Colors.black,
                  ),
                ),
                Text(
                  businesstype,
                  style: GoogleFonts.ubuntu(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    // color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Get.to(() => ImageGallery(
                        bid: bid,
                      ));
                },
                icon: Icon(LucideIcons.image))
          ]),
    );
  }
}
