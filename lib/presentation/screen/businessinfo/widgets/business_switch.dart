import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessSwitch extends StatelessWidget {
  final bool isAnalyticsSelected;
  final ValueChanged<bool> onToggle;

  const BusinessSwitch({
    super.key,
    required this.isAnalyticsSelected,
    required this.onToggle,
  });

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
                onPressed: () => onToggle(true),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent,
                ),
                child: Text(
                  "Business Analytics",
                  style: GoogleFonts.ubuntu(
                    fontSize: isAnalyticsSelected ? 17 : 16,
                    fontWeight: FontWeight.w600,
                    color: isAnalyticsSelected
                        ? Color(0xffFF750C)
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.indigo.shade50
                            : Colors.black54,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => onToggle(false),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent,
                ),
                child: Text(
                  "Business Details",
                  style: GoogleFonts.ubuntu(
                    fontSize: isAnalyticsSelected ? 16 : 17,
                    fontWeight: FontWeight.w600,
                    color: !isAnalyticsSelected
                        ? Color(0xffFF750C)
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.indigo.shade50
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
