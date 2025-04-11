import 'dart:ui';
import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/dashboard/widget/percent_widget.dart';
import 'package:brandsinfo/presentation/screen/splash/splash_controller.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String locality;
  final int views;
  final String score;
  final String? image;
  final String plan;

  const BusinessCard({
    super.key,
    required this.name,
    required this.locality,
    required this.views,
    this.image,
    required this.score,
    required this.plan,
  });
  double convertProgressStringToDouble(String score) {
    try {
      return double.parse(score) / 100;
    } catch (e) {
      print("Error converting progress string to double: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = convertProgressStringToDouble(score);

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : Colors.indigo.shade50,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 4, 15),
                      child: SizedBox(
                        width: Get.size.width / 4.5,
                        height: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: image != null
                              ? Image.network(
                                  "${ApiConstants.apiurl}$image",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    CommonSizedBox.w5,
                    Expanded(
                      // 🔹 Wrap content inside Expanded
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                            SizedBox(height: 10),
                            Text(
                              locality,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                            SizedBox(height: 5),
                            // Text(plan),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.remove_red_eye,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 5),
                                Text(
                                  "$views Views",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Spacer(),
                                plan != "Default Plan"
                                    ? Text(plan)
                                    : ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 5),
                                          minimumSize: Size(10, 10),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          "Promote",
                                          style: TextStyle(
                                              fontSize:
                                                  11), // Optional: make text smaller
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     // circular_percent_widget(
                    //     //   color: Color(0xffFF750C),
                    //     //   radious: 30,
                    //     //   score: score,
                    //     //   percent: progressValue,
                    //     //   linewidth: 4.0,
                    //     // ),
                    //     // CommonSizedBox.h5,
                    //     Text(plan)
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
