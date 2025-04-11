import 'package:brandsinfo/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class CategoryModel {
  final String id;
  final String catName;

  CategoryModel({required this.id, required this.catName});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      catName: json['cat_name'],
    );
  }
}

class AddCategoryController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  // Observable variables
  RxList<CategoryModel> suggestions = <CategoryModel>[].obs;
  RxList<CategoryModel> selectedCategories =
      <CategoryModel>[].obs; // New list for selected categories
  RxBool isSearching = false.obs;
  RxBool isAdding = false.obs;

  Timer? _debounce;
  String bid = '';

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void setBid(String businessId) {
    bid = businessId;
  }

  void searchCategories(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) return;

      isSearching.value = true;
      suggestions.clear();

      try {
        final response =
            await _apiService.get("/users/suggestions_bdcats/?q=$query");

        if (response != null && response['suggestions'] != null) {
          final List<dynamic> categoriesJson = response['suggestions'];
          suggestions.value = categoriesJson
              .map((category) => CategoryModel.fromJson(category))
              .toList();
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to fetch categories: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
        );
      } finally {
        isSearching.value = false;
      }
    });
  }

  void selectCategory(CategoryModel category) {
    // Check if category is already selected
    final index =
        selectedCategories.indexWhere((item) => item.id == category.id);

    if (index != -1) {
      // Already selected, remove it
      // selectedCategories.removeAt(index);
    } else {
      // Not selected, add it
      selectedCategories.add(category);
    }
  }

  bool isCategorySelected(String categoryId) {
    return selectedCategories.any((category) => category.id == categoryId);
  }

  void removeCategory(String categoryId) {
    print('Removing category with ID: $categoryId');
    print(
        'Before removal: ${selectedCategories.map((c) => "${c.id}:${c.catName}").toList()}');
    selectedCategories.removeWhere((category) => category.id == categoryId);
    print(
        'After removal: ${selectedCategories.map((c) => "${c.id}:${c.catName}").toList()}');
  }

  Future<void> addCategory() async {
    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (bid.isEmpty) {
      Get.snackbar(
        'Error',
        'Business ID is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
      return;
    }

    isAdding.value = true;

    try {
      // Get the array of selected category IDs
      List<String> categoryIds =
          selectedCategories.map((cat) => cat.id).toList();

      final payload = {"bid": bid, "dcid": categoryIds};

      final response = await _apiService.post("/users/add_descats/", payload,
          useSession: true);

      if (response.statusCode == 200) {
        // Return the list of selected category IDs to the previous screen
        Get.back(result: categoryIds);
        Get.snackbar(
          'Success',
          'Categories added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add categories',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    } finally {
      isAdding.value = false;
    }
  }
}
