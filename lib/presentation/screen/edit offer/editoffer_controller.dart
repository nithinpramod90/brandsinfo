import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditOfferController extends GetxController {
  // Form fields
  final businessId = "".obs;
  final offerId = 0.obs;
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

  // Initialize with offer data
  void initWithOffer(Map<String, dynamic> offerData) {
    businessId.value = offerData['business'].toString();
    offerId.value = offerData['id'];
    isFlat.value = offerData['is_flat'];
    isPercent.value = offerData['is_percent'];
    offerType.value = offerData['is_flat'] ? "Flat" : "Percentage";
    minimumBillAmount.text = offerData['minimum_bill_amount'].toString();
    offerAmount.text = offerData['offer'].toString();

    if (offerData['valid_upto'] != null) {
      try {
        validUpto.value = DateTime.parse(offerData['valid_upto']);
      } catch (e) {
        validUpto.value = DateTime.now().add(const Duration(days: 14));
      }
    }
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
  Future<void> updateOffer() async {
    if (formKey.currentState!.validate()) {
      try {
        Loader.show();
        isLoading(true);

        // Prepare data for API
        final Map<String, dynamic> offerData = {
          'buisness': businessId.value,
          'is_flat': isFlat.value,
          'is_percent': isPercent.value,
          'minimum_bill_amount': double.parse(minimumBillAmount.text),
          'offer': int.parse(offerAmount.text),
          'valid_upto': getFormattedDate(),
        };

        // Make API call
        final response = await apiService.patch(
          '/users/offers/edit/${offerId.value}',
          offerData,
        );

        if (response.statusCode == 200) {
          Loader.hide();
          Get.back(result: true);
          Get.snackbar(
            'Success',
            'Offer updated successfully',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
        } else {
          Loader.hide();
          Get.snackbar(
            'Error',
            'Failed to update offer',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      } catch (e) {
        Loader.hide();
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
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
    if (double.tryParse(value) == null) {
      print(double.tryParse(value));
      return 'Please enter a valid number';
    }
    return null;
  }

  // Validation for offer amount with percentage check
  String? validateOfferAmount(String? value) {
    // First run the basic validation
    final basicValidation = validateAmount(value);
    if (basicValidation != null) {
      return basicValidation;
    }

    // Check if percentage offer is greater than 100
    if (isPercent.value && int.parse(value!) > 100) {
      return 'Percentage cannot be greater than 100%';
    }

    return null;
  }
}
