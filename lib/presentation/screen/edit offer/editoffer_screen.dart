import 'package:brandsinfo/presentation/screen/edit%20offer/editoffer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOfferScreen extends StatelessWidget {
  final Map<String, dynamic> offerData;

  EditOfferScreen({Key? key, required this.offerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditOfferController controller = Get.put(EditOfferController());
    // Initialize controller with offer data
    controller.initWithOffer(offerData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Offer'),
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _buildForm(context, controller)),
    );
  }

  Widget _buildForm(BuildContext context, EditOfferController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offer Type Selector
            // const Text(
            //   'Offer Type',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            // Obx(() => Row(
            //       children: [
            //         Expanded(
            //           child: GestureDetector(
            //             onTap: () => controller.updateOfferType(true),
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(vertical: 12),
            //               decoration: BoxDecoration(
            //                 color: controller.isFlat.value
            //                     ? Theme.of(context).primaryColor
            //                     : Colors.grey[200],
            //                 borderRadius: const BorderRadius.only(
            //                   topLeft: Radius.circular(8),
            //                   bottomLeft: Radius.circular(8),
            //                 ),
            //               ),
            //               alignment: Alignment.center,
            //               child: Text(
            //                 'Flat',
            //                 style: TextStyle(
            //                   color: controller.isFlat.value
            //                       ? Colors.white
            //                       : Colors.black,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Expanded(
            //           child: GestureDetector(
            //             onTap: () => controller.updateOfferType(false),
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(vertical: 12),
            //               decoration: BoxDecoration(
            //                 color: controller.isPercent.value
            //                     ? Theme.of(context).primaryColor
            //                     : Colors.grey[200],
            //                 borderRadius: const BorderRadius.only(
            //                   topRight: Radius.circular(8),
            //                   bottomRight: Radius.circular(8),
            //                 ),
            //               ),
            //               alignment: Alignment.center,
            //               child: Text(
            //                 'Percentage',
            //                 style: TextStyle(
            //                   color: controller.isPercent.value
            //                       ? Colors.white
            //                       : Colors.black,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     )),
            // const SizedBox(height: 20),

            // Offer Amount
            const Text(
              'Offer Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
                  controller: controller.offerAmount,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: controller.isFlat.value
                        ? 'Enter amount (e.g., 500)'
                        : 'Enter percentage (e.g., 15)',
                    suffix: Text(controller.isPercent.value ? '%' : ''),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateOfferAmount,
                )),
            const SizedBox(height: 20),

            // Minimum Bill Amount
            const Text(
              'Minimum Bill Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.minimumBillAmount,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter minimum bill amount',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.number,
              validator: controller.validateAmount,
            ),
            const SizedBox(height: 20),

            // Valid Until Date
            const Text(
              'Valid Until',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.validUpto.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  controller.setDate(picked);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(controller.getFormattedDate())),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.updateOffer(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'UPDATE OFFER',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
