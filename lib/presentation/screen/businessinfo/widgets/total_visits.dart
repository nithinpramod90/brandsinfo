// ignore_for_file: deprecated_member_use

import 'package:brandsinfo/presentation/screen/analytics/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

class EnhancedEmeraldBlurCard extends StatelessWidget {
  const EnhancedEmeraldBlurCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.percentage,
    this.isPositive = true,
    this.icon = LucideIcons.users,
    required this.bid,
  });

  final String title;
  final String value;
  final String subtitle;
  final String percentage;
  final bool isPositive;
  final IconData icon;
  final String bid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AnalyticsDashboardScreen(
              bid: bid,
            ));
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Base white background
              Positioned.fill(
                child: Container(color: Colors.transparent),
              ),

              // Emerald gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 206, 206, 206)
                            .withOpacity(0.08),
                        Colors.orange.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
              ),

              // Main blur effect
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.9), // Optional overlay color
                  ),
                ),
              ),

              // // Glass effect overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Left side - Icon with circular background
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          // color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    SizedBox(width: 14),

                    // Middle - Main content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            value,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side - Percentage indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isPositive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? LucideIcons.trendingUp
                                : LucideIcons.trendingDown,
                            color: isPositive ? Colors.lightGreen : Colors.red,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "$percentage%",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  isPositive ? Colors.lightGreen : Colors.red,
                            ),
                          ),
                        ],
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
