import 'package:brandsinfo/presentation/screen/package/pricing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpgradeBanner extends StatelessWidget {
  final String planName;
  final VoidCallback onUpgrade;

  const UpgradeBanner({
    Key? key,
    required this.planName,
    required this.onUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.indigo.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're on $planName",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Upgrade to access analytics, product visibility, and more",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Get.to(() => SubscriptionPlansScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo.shade800,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text("Upgrade Now"),
          ),
        ],
      ),
    );
  }
}
