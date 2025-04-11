import 'dart:ui';

import 'package:brandsinfo/presentation/screen/business%20categories/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessCategoryContainer extends StatelessWidget {
  const BusinessCategoryContainer({super.key, required this.bid});
  final String bid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BusinessCategoriesScreen(
              businessId: bid,
            ));
      },
      child: Container(
        height: 70,
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
                        Colors.white.withOpacity(0.25),
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
                          Icons.business,
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
                            "Buisness Categories",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Colors.orange,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.navigate_next_outlined,
                    )
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
