import 'package:brandsinfo/network/api_service.dart';

class AnalyticsController {
  final ApiService _apiService = ApiService();

  // Analytics data model
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;
  String? error;

  AnalyticsController();

  Future<void> fetchAnalyticsData(String bid) async {
    try {
      isLoading = true;
      error = null;

      final response =
          await _apiService.get('/users/buisnesses/?bid=$bid&analytics=true');

      if (response != null && response is Map<String, dynamic>) {
        analyticsData = response;
      } else {
        error = 'Failed to fetch analytics data';
      }
    } catch (e) {
      error = 'Error fetching analytics: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  // Helper methods to easily access analytics data
  int get leads => int.tryParse(analyticsData?['leads'].toString() ?? '') ?? 0;
  int get averageTimeSpent =>
      int.tryParse(analyticsData?['average_time_spend'].toString() ?? '') ?? 0;

  int get profileViewsProgress =>
      int.tryParse(analyticsData?['profile_views_progress'].toString() ?? '') ??
      0;
  int get searchedCount =>
      int.tryParse(analyticsData?['searched'].toString() ?? '') ?? 0;
  List<Map<String, dynamic>> get mostSearchedProducts {
    return List<Map<String, dynamic>>.from(
        analyticsData?['most_serched_products'] ?? []);
  }

  List<Map<String, dynamic>> get visitsByDate {
    return List<Map<String, dynamic>>.from(analyticsData?['visits'] ?? []);
  }
}
