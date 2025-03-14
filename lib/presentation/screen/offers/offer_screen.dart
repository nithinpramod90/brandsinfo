import 'package:brandsinfo/presentation/screen/offers/offer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key, required this.bid});
  final String bid;

  @override
  Widget build(BuildContext context) {
    final OffersController controller = Get.put(OffersController(bid: bid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Offers'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        } else if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchOffers,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (controller.offers.isEmpty) {
          return const Center(child: Text('No offers available'));
        } else {
          return RefreshIndicator(
            onRefresh: controller.fetchOffers,
            color: Colors.orange,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.offers.length,
              itemBuilder: (context, index) => OfferCard(
                offer: controller.offers[index],
                controller: controller,
                onDelete: () =>
                    _showDeleteConfirmation(context, controller, index),
              ),
            ),
          );
        }
      }),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, OffersController controller, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offer'),
        content: const Text('Are you sure you want to delete this offer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Here you would call a method to delete the offer
              controller.deleteOffer(controller.offers[index].id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Offer offer;
  final OffersController controller;
  final VoidCallback onDelete;

  const OfferCard({
    Key? key,
    required this.offer,
    required this.controller,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offerDescription = controller.getOfferDescription(offer);
    final validityText = controller.getOfferValidity(offer.validUpto);
    final isExpired = validityText == 'Expired';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      offerDescription,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.shopping_cart_outlined,
                          'Min. Order: ₹${offer.minimumBillAmount.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time, validityText,
                          isExpired ? Colors.red : null),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today,
                          'Until: ${DateFormat('dd MMM yyyy').format(DateTime.parse(offer.validUpto))}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.white),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, [Color? textColor]) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor ?? (Colors.black87),
          ),
        ),
      ],
    );
  }
}
