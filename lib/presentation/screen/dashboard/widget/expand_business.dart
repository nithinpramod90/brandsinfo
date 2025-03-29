import 'package:brandsinfo/presentation/screen/business/information_screen.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandBusiness extends StatelessWidget {
  const ExpandBusiness({super.key, required this.main, required this.sub});
  final String main;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: MediaQuery.of(context).size.height / 12,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffFF750C)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              main,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Prevents text wrapping
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120, // Compact button width
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => InformationScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF750C),
                elevation: 5,
                padding: const EdgeInsets.symmetric(
                    vertical: 8), // Smaller button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add Business",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Smaller text for a compact look
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
