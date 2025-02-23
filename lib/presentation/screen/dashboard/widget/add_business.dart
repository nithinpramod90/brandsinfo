import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';

class AddBusiness extends StatelessWidget {
  const AddBusiness({super.key, required this.main, required this.sub});
  final String main;
  final String sub;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
        ),
        // color: Colors.orange.shade400, // Transparent orange background
        borderRadius: BorderRadius.circular(20.0), // Curved borders
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              main,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            CommonSizedBox.h5,
            Text(
              sub,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CommonSizedBox.h20,
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Black background
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
            )
          ],
        ),
      ),
    );
  }
}
