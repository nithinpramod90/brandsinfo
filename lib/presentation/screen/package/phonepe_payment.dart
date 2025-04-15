// PhonePePaymentController.dart
import 'package:brandsinfo/network/api_service.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // Added missing import for SHA-256

class PhonePePaymentController extends GetxController {
  RxBool isLoading = false.obs;

  String? appId;
  String? merchantId;
  String? saltKey;
  String? saltIndex;
  String? callbackUrl;
  String environment = "UAT"; // Or "PRODUCTION"
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    initPhonePeSDK(); // Initialize when controller is created
  }

  Future<void> initPhonePeSDK() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get('your-config-api-endpoint');
      if (response != null) {
        appId = response['appId'];
        merchantId = response['merchantId'];
        saltKey = response['saltKey'];
        saltIndex = response['saltIndex'];
        callbackUrl = response['callbackUrl'];

        // Fix: Use positional parameters as expected by the SDK
        bool isInitialized = await PhonePePaymentSdk.init(
          environment,
          appId ?? "",
          merchantId ?? "",
          true, // enableLogging
        );

        if (!isInitialized) {
          Get.snackbar("Error", "PhonePe SDK initialization failed");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch PhonePe config");
      }
    } catch (e) {
      Get.snackbar("Error", "Init error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startPhonePeTransaction({required int amountInPaise}) async {
    try {
      isLoading.value = true;

      if (merchantId == null ||
          saltKey == null ||
          saltIndex == null ||
          callbackUrl == null) {
        Get.snackbar("Error", "PhonePe not initialized properly");
        return;
      }

      final transactionId = "TID${DateTime.now().millisecondsSinceEpoch}";

      final payload = {
        "merchantId": merchantId,
        "transactionId": transactionId,
        "amount": amountInPaise,
        "merchantUserId": "user_${DateTime.now().millisecondsSinceEpoch}",
        "redirectUrl": callbackUrl,
        "redirectMode": "POST",
        "callbackUrl": callbackUrl,
        "paymentInstrument": {"type": "PAY_PAGE"}
      };

      final jsonBody = jsonEncode(payload);
      final base64Body = base64Encode(utf8.encode(jsonBody));

      // Fix: Correct the string for hashing
      final stringToHash = "/pg/v1/pay$base64Body$saltKey";
      final hash = sha256.convert(utf8.encode(stringToHash)).toString();
      final checksum = "$hash###$saltIndex";

      // Fix: startTransaction expects String parameters
      final result = await PhonePePaymentSdk.startTransaction(
        base64Body,
        transactionId,
      );

      if (result != null && result['status'] == 'SUCCESS') {
        Get.snackbar("Success", "Payment completed!");
      } else {
        Get.snackbar("Failed",
            "Payment failed or cancelled: ${result?['error'] ?? 'Unknown error'}");
      }
    } catch (e) {
      Get.snackbar("Error", "Transaction failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
