import 'package:brandsinfo/network/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class RevenueChartController extends GetxController {
  final ApiService _apiService = ApiService(); // Get the ApiService instance

  // Observable variables
  RxString selectedFilter = "Weekly".obs;
  RxList<Map<String, dynamic>> chartData = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  // Your specific API endpoints
  final Map<String, String> endpoints = {
    "Daily": "buisnesses/?bid=94&analytics=true",
    "Weekly":
        "buisnesses/?bid=94&analytics=true", // Same as daily for weekly view
    "Monthly": "buisnesses/?bid=94&analytics=true&month=true",
    "Yearly": "buisnesses/?bid=94&analytics=true&yearly=true"
  };

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Load initial data
  }

  // Change filter and fetch new data
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchData();
  }

  // Fetch data based on selected filter
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      final endpoint = endpoints[selectedFilter.value] ?? endpoints["Weekly"]!;
      final response = await _apiService.get(endpoint);

      // Process response data
      if (response != null && response['data'] != null) {
        final List<dynamic> responseData = response['data'];

        // Transform API data to chart format
        chartData.value = responseData.map<Map<String, dynamic>>((item) {
          return {
            "date": item['date'] ?? DateTime.now().toIso8601String(),
            "count": item['count'] ?? 0,
          };
        }).toList();
      } else {
        // Fallback to sample data for testing
        _loadSampleData();
      }
    } catch (e) {
      print('Error fetching chart data: $e');
      // Load sample data on error
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  // Load sample data for testing or when API fails
  void _loadSampleData() {
    // Generate sample data based on the current filter
    final today = DateTime.now();
    final List<Map<String, dynamic>> sampleData = [];

    switch (selectedFilter.value) {
      case "Daily":
      case "Weekly":
        // Last 7 days for weekly
        for (int i = 6; i >= 0; i--) {
          final date = today.subtract(Duration(days: i));
          sampleData.add({
            "date": DateFormat('yyyy-MM-dd').format(date),
            "count":
                (math.Random().nextInt(90) + 10), // Random value between 10-100
          });
        }
        break;

      case "Monthly":
        // Last 30 days summarized by week
        for (int i = 0; i < 4; i++) {
          final date = today.subtract(Duration(days: i * 7));
          sampleData.add({
            "date": DateFormat('yyyy-MM-dd').format(date),
            "count": (math.Random().nextInt(300) +
                100), // Random value between 100-400
          });
        }
        break;

      case "Yearly":
        // Last 12 months
        for (int i = 11; i >= 0; i--) {
          final date = DateTime(today.year, today.month - i, 1);
          sampleData.add({
            "date": DateFormat('yyyy-MM-dd').format(date),
            "count": (math.Random().nextInt(900) +
                100), // Random value between 100-1000
          });
        }
        break;
    }

    chartData.value = sampleData;
  }

  // Get stats for indicators
  int getTotal() {
    if (chartData.isEmpty) return 0;
    return chartData.fold(0, (sum, item) => sum + (item["count"] as int));
  }

  double getAverage() {
    if (chartData.isEmpty) return 0;
    return getTotal() / chartData.length;
  }

  int getMax() {
    if (chartData.isEmpty) return 0;
    return chartData
        .map((e) => e["count"] as int)
        .reduce((a, b) => a > b ? a : b);
  }
}
