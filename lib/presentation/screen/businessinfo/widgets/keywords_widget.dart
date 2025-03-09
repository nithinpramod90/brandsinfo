import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KeywordsWidget extends StatelessWidget {
  const KeywordsWidget({super.key, required this.sa, required this.keywords});
  final String sa;
  final List<dynamic> keywords;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 220,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        color: Color(0xFF515050),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SvgPicture.asset(
              'assets/svg/dots.svg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay on the right side
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: Get.width,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF555555),
                    Color(0xFF515050),
                  ],
                ),
              ),
            ),
          ),
          // Text in the center
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style, // Inherit default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: 'You appeared in ',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ), // Regular text

                      TextSpan(
                        text: sa,
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF750C),
                        ),
                      ),
                      TextSpan(
                        text: ' search results the \nlast week',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ), // Regular text
                    ],
                  ),
                ),
                CommonSizedBox.h20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keywords that you appear in",
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    CommonSizedBox.h10,
                    Row(
                      children: [
                        Text(
                          keywords[0] ?? '',
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        CommonSizedBox.w10,
                        Text(
                          keywords[1] ?? '',
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        CommonSizedBox.w10,
                        Text(
                          keywords[2] ?? '',
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    CommonSizedBox.h10,
                    Text(
                      "View all >",
                      style: GoogleFonts.ubuntu(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Move "More" text and arrow to bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Increase your visibility',
                    style: GoogleFonts.ubuntu(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  CommonSizedBox.h5,
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF750C),
                      minimumSize:
                          Size.zero, // Make the button as small as possible
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5), // Adjust padding for size
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // Shrink the tap target
                    ),
                    child: Text(
                      "Add More Keywords",
                      style: GoogleFonts.ubuntu(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
