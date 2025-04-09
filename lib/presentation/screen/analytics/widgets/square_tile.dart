import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';

class ProgressContainer extends StatelessWidget {
  final int number;
  final String text;
  final double progress;
  final Color color;
  final Color txtcolour;

  const ProgressContainer({
    super.key,
    required this.number,
    required this.text,
    required this.progress,
    required this.color,
    required this.txtcolour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: txtcolour),
          ),
          CommonSizedBox.h5,
          Text(
            text,
            style: TextStyle(fontSize: 16, color: txtcolour),
            textAlign: TextAlign.center,
          ),
          CommonSizedBox.h5,
          // Row(
          //   mainAxisAlignment:
          //       MainAxisAlignment.spaceBetween, // Ensures spacing
          //   children: const [
          //     Text(
          //       "0%",
          //       style: TextStyle(fontSize: 14, color: Colors.black),
          //     ),
          //     Text(
          //       "100%",
          //       style: TextStyle(fontSize: 14, color: Colors.black),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   width: 150,
          //   child: LinearProgressIndicator(
          //     value: progress / 100, // Convert to range 0-1
          //     backgroundColor: Colors.black,
          //     valueColor: AlwaysStoppedAnimation<Color>(color),
          //   ),
          // ),
        ],
      ),
    );
  }
}
