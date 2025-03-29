import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/offers/offer_screen.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddOfferController extends GetxController {
  // Form fields
  final businessId = "31".obs; // Default business ID
  final isFlat = true.obs;
  final isPercent = false.obs;
  final minimumBillAmount = TextEditingController();
  final offerAmount = TextEditingController();
  final offerType = "Flat".obs;
  final validUpto = DateTime.now().add(const Duration(days: 14)).obs;
  final ApiService apiService = ApiService();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Loading state
  final isLoading = false.obs;

  // Initialize with a business ID
  void setBusinessId(String bid) {
    businessId.value = bid;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    minimumBillAmount.dispose();
    offerAmount.dispose();
    super.onClose();
  }

  // Update offer type based on selection
  void updateOfferType(bool flat) {
    isFlat.value = flat;
    isPercent.value = !flat;
    offerType.value = flat ? "Flat" : "Percentage";
  }

  // Set date
  void setDate(DateTime date) {
    validUpto.value = date;
  }

  // Format date for display
  String getFormattedDate() {
    return DateFormat('yyyy-MM-dd').format(validUpto.value);
  }

  // Submit form
  Future<void> submitOffer() async {
    if (formKey.currentState!.validate()) {
      try {
        Loader.show();
        // Prepare data for API
        final Map<String, dynamic> offerData = {
          'buisness': businessId.value,
          'is_flat': isFlat.value,
          'is_percent': isPercent.value,
          'minimum_bill_amount': int.parse(minimumBillAmount.text),
          'offer': int.parse(offerAmount.text),
          'offer_type': offerType.value,
          'valid_upto': getFormattedDate(),
        };

        print('Submitting offer data: $offerData'); // Debug print

        // Make API call
        final response = await apiService.post(
          '/users/offers/add/',
          offerData,
          useSession: true,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Loader.hide();
          Get.back(result: true);
        } else {
          Loader.hide();

          Get.snackbar('Error', 'Failed to add offer');
        }
      } catch (e) {
        Loader.hide();

        print(e);
        Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        Loader.hide();

        isLoading(false);
      }
    }
  }

  // Validation
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
