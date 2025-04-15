import 'package:flutter/material.dart';

class ProductServiceSelector extends StatelessWidget {
  final String businessType; // Changed to String
  final Function() onProductTap;
  final Function() onServiceTap;

  const ProductServiceSelector({
    Key? key,
    required this.businessType,
    required this.onProductTap,
    required this.onServiceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine which buttons to show based on the string
    final bool showProductButton =
        businessType == 'Product' || businessType == 'Products & Services';
    final bool showServiceButton =
        businessType == 'Service' || businessType == 'Products & Services';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showProductButton)
              Expanded(
                child: _buildButton(
                  context: context,
                  label: 'Products',
                  icon: Icons.inventory_2_outlined,
                  onTap: onProductTap,
                ),
              ),
            if (showProductButton && showServiceButton)
              const SizedBox(width: 16),
            if (showServiceButton)
              Expanded(
                child: _buildButton(
                  context: context,
                  label: 'Services',
                  icon: Icons.handyman_outlined,
                  onTap: onServiceTap,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Function() onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.indigo.shade50 // Dark mode color
            : Colors.black38, // Light mode color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blueGrey.shade100),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            // color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // color: Colors.blueGrey[700],
            ),
          ),
        ],
      ),
    );
  }
}
