import 'package:brandsinfo/network/api_service.dart';
import 'package:get/get.dart';

class BusinessCategory {
  final int id;
  final String catName;

  BusinessCategory({required this.id, required this.catName});

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      id: json['id'],
      catName: json['cat_name'],
    );
  }
}

class BusinessCategoriesController extends GetxController {
  final ApiService _apiService = ApiService();

  var categories = <BusinessCategory>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxString('');

  Future<void> fetchCategories(String businessId) async {
    try {
      isLoading(true);
      errorMessage('');

      final response =
          await _apiService.get("/users/get_bdcats/?bid=$businessId");

      if (response is List) {
        categories.value =
            response.map((item) => BusinessCategory.fromJson(item)).toList();
      } else if (response is Map) {
        categories.value = [];
      } else {
        categories.value = List<BusinessCategory>.from(
            (response as List).map((item) => BusinessCategory.fromJson(item)));
      }
    } catch (e) {
      errorMessage('Failed to fetch categories: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      isLoading(true);
      https: //api.brandsinfo.in54/

      // Assuming there's an endpoint for deleting a category
      await _apiService.delete("/users/dlt_descats/$categoryId/");

      // Remove the category from the list
      categories.removeWhere((category) => category.id == categoryId);
    } catch (e) {
      errorMessage('Failed to delete category: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(String businessId, String categoryName) async {
    try {
      isLoading(true);

      // Assuming there's an endpoint for adding a category
      await _apiService.post(
          "/users/add_bdcat/", {"bid": businessId, "cat_name": categoryName});

      // Refresh the categories after adding
      await fetchCategories(businessId);
    } catch (e) {
      errorMessage('Failed to add category: ${e.toString()}');
      isLoading(false);
    }
  }
}
