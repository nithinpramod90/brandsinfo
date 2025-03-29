import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  final searchQuery = ''.obs;
  final recentSearches = <String>[].obs;

  void addSearch(String query) {
    if (query.trim().isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      // Limit recent searches list to 10 items
      if (recentSearches.length > 10) recentSearches.removeLast();
    }
    searchQuery.value = '';
  }

  void selectRecentSearch(String query) {
    searchQuery.value = query;
  }
}
