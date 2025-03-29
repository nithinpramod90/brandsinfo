import 'dart:ui';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/information/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScoreWidget extends StatelessWidget {
  final int score;
  final String bid;
  final double size;
  final VoidCallback? onIncreasePressed;

  const ProfileScoreWidget({
    Key? key,
    required this.score,
    this.size = 200,
    this.onIncreasePressed,
    required this.bid,
  }) : super(key: key);

  // Get color based on score
  Color _getScoreColor(int score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  // Get gradient colors based on score
  List<Color> _getGradientColors(int score) {
    if (score < 40) {
      return [Colors.red.shade300, Colors.red.shade700];
    } else if (score < 70) {
      return [Colors.orange.shade300, Colors.orange.shade700];
    } else {
      return [Color(0xFF10B981), Color(0xFF10B981)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(score);
    final gradientColors = _getGradientColors(score);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final BusinessinfoController controller = Get.put(BusinessinfoController());
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailsScreen(
                  bid: bid,
                ))!
            .then((_) => controller.fetchBusinessData());

        // Get.to(() => DetailsScreen(
        //       bid: bid,
        //     ));
      },
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: scoreColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress indicator
              SizedBox(
                width: size * 2,
                height: size * 2,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),

              // Inner circular gradient
              Container(
                width: size * 2,
                height: size * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      gradientColors[0].withOpacity(0.2),
                      gradientColors[1].withOpacity(0.05),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),

              // Score content
              Padding(
                padding: EdgeInsets.all(size * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Profile Score",
                      style: GoogleFonts.poppins(
                        fontSize: size * 0.08,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: size * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          score.toString(), // Convert int to String
                          style: GoogleFonts.poppins(
                            fontSize: size * 0.2,
                            fontWeight: FontWeight.w700,
                            color: scoreColor,
                          ),
                        ),
                        Text(
                          "/100",
                          style: GoogleFonts.poppins(
                            fontSize: size * 0.1,
                            fontWeight: FontWeight.w400,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: size * 0.05),
                    ElevatedButton.icon(
                      onPressed: onIncreasePressed ??
                          () {
                            Get.to(() => DetailsScreen(
                                      bid: bid,
                                    ))!
                                .then((_) => controller.fetchBusinessData());
                          }, // Add fallback empty function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scoreColor.withOpacity(0.2),
                        foregroundColor: scoreColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: size * 0.1,
                          vertical: size * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      icon: Icon(
                        Icons.trending_up,
                        size: size * 0.06,
                      ),
                      label: Text(
                        "Boost Score",
                        style: GoogleFonts.poppins(
                          fontSize: size * 0.06,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
