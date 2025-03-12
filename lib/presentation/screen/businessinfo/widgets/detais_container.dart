import 'dart:ui';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassmorphicDetailsContainer extends StatelessWidget {
  const GlassmorphicDetailsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, 'Phone', '9248796138'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.email, 'Email', 'starbucks@gmail.com'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Address',
                  'Starbucks 7th cross road HBR layout, near Anjanaya Swamy temple, Bengaluru, Karnataka, 809580'),
              const SizedBox(height: 12),
              _buildTimingRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.orange,
          size: 14,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.ubuntu(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimingRow() {
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          color: Colors.orange,
          size: 14,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Opens at',
                    style: GoogleFonts.ubuntu(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '9:00 AM',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              CommonSizedBox.w20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Closes at',
                    style: GoogleFonts.ubuntu(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '9:00 PM',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
