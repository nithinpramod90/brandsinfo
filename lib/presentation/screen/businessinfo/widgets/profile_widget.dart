import 'package:brandsinfo/presentation/screen/businessinfo/widgets/horizontal_progressbar.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.score});
  final String score;
  double? convertProgressStringToDouble(String score) {
    try {
      return double.parse(score) / 100;
    } catch (e) {
      print("Error converting progress string to double: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double? progressValue = convertProgressStringToDouble(score);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffFF750C)),
        borderRadius: BorderRadius.circular(12.0), // Curved borders
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Complete you profile to increase visibility",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CommonSizedBox.h10,
                SizedBox(
                  width: 270,
                  child: Column(
                    children: [
                      if (progressValue != null)
                        HorizontalProgressBar(
                          progress: progressValue,
                        )
                      else
                        const Text(
                            "Invalid score for progress bar"), // Or a loading indicator
                    ],
                  ),
                )
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Profile Score",
                  style: GoogleFonts.ubuntu(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                Text(
                  score,
                  style: GoogleFonts.ubuntu(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    height: 1, // Forces text to have no extra spacing
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
