import 'package:brandsinfo/presentation/screen/enquiries/enquires_screen.dart';
import 'package:brandsinfo/presentation/screen/offers/offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Offerenquiry extends StatelessWidget {
  const Offerenquiry({super.key, required this.bid});
  final String bid;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ServiceCard(
              onTap: () {
                Get.to(() => OffersScreen(bid: bid));
              },
              title: "Offers",
              description: "Exclusive deals & promotions",
              iconPath: "assets/svg/offers.svg",
              backgroundColor: Color.fromARGB(255, 39, 39, 39),
              textColor: Colors.white,
            ),
            // ServiceCard(
            //   onTap: () {
            //     Get.to(() => EnquiriesScreen());
            //   },
            //   title: "Enquries",
            //   description: "Contact our support team",
            //   iconPath: "assets/svg/enquiry.svg",
            //   backgroundColor: Color.fromARGB(255, 233, 232, 232),
            //   textColor: Colors.black,
            // ),
          ],
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: Get.size.width / 1.2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 80,
                  width: 80,
                  // color: textColor,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
