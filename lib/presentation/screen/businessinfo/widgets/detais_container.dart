import 'dart:ui';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassmorphicDetailsContainer extends StatelessWidget {
  const GlassmorphicDetailsContainer(
      {super.key,
      required this.phone,
      required this.email,
      required this.address,
      required this.opens,
      required this.close});
  final String phone;
  final String email;
  final String address;
  final String opens;
  final String close;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
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
              // const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, 'Phone', phone),
              Divider(
                thickness: 0.5,
              ),
              // const SizedBox(height: 12),
              _buildInfoRow(Icons.email, 'Email', email),
              Divider(
                thickness: 0.5,
              ),
              // const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Address', address),
              Divider(
                thickness: 0.5,
              ),
              // const SizedBox(height: 12),
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
          // color: Colors.orange,
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
                  // color: Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.ubuntu(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade200,
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
          // color: Colors.orange,
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
                      // color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    opens,
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
                      // color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    close,
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
