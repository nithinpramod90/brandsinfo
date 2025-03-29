import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: Get.size.height / 2,
          decoration: BoxDecoration(
            color: Colors.black26,

            border: Border.all(
              // Correct way to add a border
              color: Colors.grey, // Border color
              width: 2, // Border width
            ),
            borderRadius: BorderRadius.circular(20), // Rounded corners
            // color: Colors.white, // Background color
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/no_not.png",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              CommonSizedBox.h10,
              Text(
                "No Notifications",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  // color: Colors.orange,
                ),
              ),
              CommonSizedBox.h10,
              Text(
                "There is no notifications to display at this time.Please check back later",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  // color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
