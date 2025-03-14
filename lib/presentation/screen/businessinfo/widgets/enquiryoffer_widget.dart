import 'package:brandsinfo/presentation/screen/businessinfo/widgets/productsandservice_button.dart';
import 'package:brandsinfo/presentation/screen/offers/offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnquiryofferWidget extends StatelessWidget {
  const EnquiryofferWidget({super.key, required this.bid});
  final String bid;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Products Container
          GlassmorphicContainer(
            title: 'Offers',
            icon: Icons.local_offer_outlined,
            onTap: () {
              Get.to(() => OffersScreen(bid: bid));
            },
          ),

          const SizedBox(width: 20), // Space between containers

          // Services Container
          GlassmorphicContainer(
            title: 'Enquiry',
            icon: Icons.contact_page_outlined,
            onTap: () {
              debugPrint('Service clicked');
              // Show a snackbar when clicked
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service selected'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
