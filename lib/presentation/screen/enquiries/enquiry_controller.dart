import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/enquiries/enquiry_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EnquiriesController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<EnquiryModel> enquiries = <EnquiryModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEnquiries();
  }

  Future<void> fetchEnquiries() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _apiService.get('/users/enquiries/');

      if (response is List) {
        enquiries.value = (response as List)
            .map((enquiry) => EnquiryModel.fromJson(enquiry))
            .toList();
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String formatDateAndTime(String date, String time) {
    try {
      final DateTime dateTime = DateTime.parse('$date $time');
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return '$date • ${time.split('.').first}';
    }
  }

  void markAsRead(int id) async {
    // Implementation for marking an enquiry as read
    // You would typically make an API call here
    try {
      // await _apiService.put('/users/enquiries/$id/', {'is_read': true});

      // Optimistic update
      final index = enquiries.indexWhere((element) => element.id == id);
      if (index != -1) {
        final updatedEnquiry = enquiries[index].copyWith(isRead: true);
        enquiries[index] = updatedEnquiry;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark enquiry as read');
    }
  }

  void refreshEnquiries() {
    fetchEnquiries();
  }
}
