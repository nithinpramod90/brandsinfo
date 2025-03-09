import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessSwitch extends StatefulWidget {
  const BusinessSwitch({super.key});

  @override
  BusinessSwitchState createState() => BusinessSwitchState();
}

class BusinessSwitchState extends State<BusinessSwitch> {
  bool isAnalyticsSelected = true; // Default selection

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isAnalyticsSelected = true;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove padding
                  minimumSize: Size.zero, // Remove minimum size
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent, // Remove ripple effect
                ),
                child: Text(
                  "Business Analytics",
                  style: GoogleFonts.ubuntu(
                    fontSize: isAnalyticsSelected ? 17 : 16,
                    fontWeight: FontWeight.w600,
                    color: isAnalyticsSelected
                        ? Color(0xffFF750C)
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.indigo.shade50 // Dark mode color
                            : Colors.black54,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    isAnalyticsSelected = false;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove padding
                  minimumSize: Size.zero, // Remove minimum size
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, //Optional, if you want to also reduce the tap area.
                  overlayColor: Colors.transparent, // Remove ripple effect
                ),
                child: Text(
                  "Business Details",
                  style: GoogleFonts.ubuntu(
                    fontSize: isAnalyticsSelected ? 16 : 17,
                    fontWeight: FontWeight.w600,
                    color: !isAnalyticsSelected
                        ? Color(0xffFF750C)
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.indigo.shade50 // Dark mode color
                            : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          color: Color.fromARGB(255, 207, 207, 207),
        ),
      ],
    );
  }
}
