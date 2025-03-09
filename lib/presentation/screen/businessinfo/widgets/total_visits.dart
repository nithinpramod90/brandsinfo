import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TotalVisitsCard extends StatelessWidget {
  const TotalVisitsCard(
      {super.key,
      required this.views,
      required this.progress,
      required this.leads});
  final String views;
  final String progress;
  final String leads;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3, // 2/3 of the row width
          child: Container(
            height: 100,
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
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // Dots SVG in the background
                Positioned(
                  top: 2,
                  left: 0,
                  child: SvgPicture.asset(
                    'assets/svg/dots.svg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay on the right side
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: Get.width * 0.4,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.white.withOpacity(1),
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                // Text in the center
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            views,
                            style: GoogleFonts.ubuntu(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFF750C),
                            ),
                          ),
                          Text(
                            "People viewed your\nbusiness",
                            style: GoogleFonts.ubuntu(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.2),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.arrowUp,
                                color: Colors.green,
                                size: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                "$progress%",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Than last week',
                            style: GoogleFonts.ubuntu(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Move "More" text and arrow to bottom right
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'More',
                          style: GoogleFonts.ubuntu(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFF750C),
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: Color(0xffFF750C),
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10), // Space between containers
        Expanded(
          flex: 1, // 1/3 of the row width
          child: Container(
            height: 100,
            // width: 100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 2, // Adjust this value to scale the SVG
                      child: SvgPicture.asset(
                        'assets/svg/leads.svg',
                        fit: BoxFit.contain, // Ensure it scales properly
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          leads,
                          style: GoogleFonts.ubuntu(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Leads",
                          style: GoogleFonts.ubuntu(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
