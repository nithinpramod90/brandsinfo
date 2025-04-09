import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/edit%20offer/editoffer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Offer {
  final int id;
  final int business;
  final dynamic offer;
  final bool isPercent;
  final bool isFlat;
  final double minimumBillAmount;
  final String validUpto;

  Offer({
    required this.id,
    required this.business,
    required this.offer,
    required this.isPercent,
    required this.isFlat,
    required this.minimumBillAmount,
    required this.validUpto,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      business: json['buisness'],
      offer: json['offer'],
      isPercent: json['is_percent'],
      isFlat: json['is_flat'],
      minimumBillAmount: json['minimum_bill_amount'].toDouble(),
      validUpto: json['valid_upto'],
    );
  }
}

class OffersController extends GetxController {
  final String bid;
  final ApiService _apiService = ApiService();

  OffersController({required this.bid});

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var offers = <Offer>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    isLoading(true);
    hasError(false);
    errorMessage('');

    try {
      // Use the ApiService to make the request
      final response = await _apiService.get('/users/offers/?bid=$bid');

      if (response != null) {
        // If response is a List, use it directly, otherwise extract the list from the response
        final List<dynamic> offersList =
            response is List ? response : response['data'] ?? [];
        offers.value = offersList.map((data) => Offer.fromJson(data)).toList();
      } else {
        hasError(true);
        errorMessage('Failed to load offers. Response was null.');
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteOffer(int offerId) async {
    try {
      // Make API call to delete offer
      final response =
          await _apiService.delete('/users/offers/delete/$offerId/');
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Offer deleted successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
      fetchOffers();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to delete offer',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> editOffer(Offer offer) async {
    try {
      // Convert Offer to a map for editing
      Map<String, dynamic> offerData = {
        'id': offer.id,
        'business': offer.business,
        'offer': offer.offer,
        'is_percent': offer.isPercent,
        'is_flat': offer.isFlat,
        'minimum_bill_amount': offer.minimumBillAmount,
        'valid_upto': offer.validUpto,
      };

      // Navigate to edit screen and wait for result
      final shouldRefresh =
          await Get.to(() => EditOfferScreen(offerData: offerData));

      // Refresh offers list if changes were made
      if (shouldRefresh == true) {
        fetchOffers();
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to edit offer',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  String getOfferDescription(Offer offer) {
    if (offer.isPercent) {
      return '${offer.offer}% OFF';
    } else if (offer.isFlat) {
      return '₹${offer.offer} OFF';
    } else {
      return 'Special Offer';
    }
  }

  String getOfferValidity(String validUpto) {
    DateTime validDate = DateTime.parse(validUpto);
    DateTime now = DateTime.now();
    int daysLeft = validDate.difference(now).inDays;

    if (daysLeft < 0) {
      return 'Expired';
    } else if (daysLeft == 0) {
      return 'Expires today';
    } else if (daysLeft == 1) {
      return 'Expires tomorrow';
    } else {
      return 'Expires in $daysLeft days';
    }
  }
}
