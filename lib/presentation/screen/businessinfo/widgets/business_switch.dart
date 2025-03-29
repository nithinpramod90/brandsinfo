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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOption(
                    label: "Analytics",
                    isSelected: isAnalyticsSelected,
                    onTap: () => onToggle(true),
                  ),
                  const SizedBox(width: 12),
                  _buildOption(
                    label: "Details",
                    isSelected: !isAnalyticsSelected,
                    onTap: () => onToggle(false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF1E1E1E) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
