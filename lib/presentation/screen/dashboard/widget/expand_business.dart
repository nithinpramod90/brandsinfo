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
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffFF750C),
        ),
        // color: Color(0xffFF750C).shade400, // Transparent orange background
        borderRadius: BorderRadius.circular(8.0), // Curved borders
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  main,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // CommonSizedBox.h5,
                // Text(
                //   sub,
                //   style: Theme.of(context).textTheme.bodyMedium,
                // ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Get.to(() => InformationScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF750C), // Black background
                elevation: 5, // Elevation for the "raised" effect
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: Text("Add Business",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            CommonSizedBox.w10
          ],
        ),
      ),
    );
  }
}
