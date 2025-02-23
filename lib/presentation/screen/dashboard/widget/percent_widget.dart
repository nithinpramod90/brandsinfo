import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class circular_percent_widget extends StatelessWidget {
  const circular_percent_widget({
    super.key,
    required this.color,
    required this.radious,
    required this.score,
    required this.percent,
  });
  final Color color;
  final String score;
  final double percent;
  final double radious;
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radious,
      lineWidth: 4.0,
      percent: percent,
      center: Text(score,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      progressColor: color,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round, // Makes start and end rounded
    );
  }
}
