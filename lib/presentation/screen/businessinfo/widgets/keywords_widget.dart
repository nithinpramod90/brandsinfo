import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brandsinfo/widgets/sized_box.dart';

class KeywordsWidget extends StatelessWidget {
  const KeywordsWidget({super.key, required this.sa, required this.keywords});
  final String sa;
  final List<dynamic> keywords;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D2D2D),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(100),
                ),
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1,
                  colors: [
                    const Color(0xFFFF750C).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SvgPicture.asset(
              'assets/svg/dots.svg',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section with search appearance count
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'You appeared in ',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.2,
                        ),
                      ),
                      TextSpan(
                        text: sa,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF750C),
                          letterSpacing: 0.2,
                        ),
                      ),
                      TextSpan(
                        text: ' search results',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'the last week',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.2,
                  ),
                ),

                // Bottom section with keywords
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 12),
                      width: 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF750C),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      "Top keywords for your brand",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: keywords.take(3).map((keyword) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(5),
                              // border: Border.all(
                              //   color: const Color(0xFFFF750C).withOpacity(0.3),
                              //   width: 1,
                              // ),
                            ),
                            child: Text(
                              keyword.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
