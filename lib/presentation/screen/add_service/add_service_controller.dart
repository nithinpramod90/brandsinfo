import 'dart:io';

import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';

class Services {
  String name, description;
  double price;
  String image;
  int categoryId;

  Services({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.categoryId,
  });
}

class ServicesController extends GetxController {
  var service = <Services>[].obs;
  var showTitle = false.obs;
  var categoryId = 0.obs;
  var serviceCategories =
      <Map<String, dynamic>>[].obs; // Store category names & IDs

  void addProduct(Services services) {
    service.add(services);
  }

  void toggleTitle(bool value) {
    showTitle.value = value;
  }

  Future<void> addServiceCategory(String catName, String businessId) async {
    Loader.show();
    try {
      final response = await ApiService().post(
        "/users/servicecats/",
        {
          "cat_name": catName,
          "buisness": businessId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        int newCategoryId = response.data["id"];
        categoryId.value = newCategoryId;

        serviceCategories.add({
          "id": newCategoryId,
          "name": catName,
        });

        toggleTitle(true);
        Loader.hide();

        CommonSnackbar.show(
            title: "Success", message: "Category added", isError: false);
      } else {
        Loader.hide();
        CommonSnackbar.show(
            title: "Error", message: "Failed to add category", isError: true);
      }
    } catch (e) {
      Loader.hide();
      CommonSnackbar.show(
          title: "Error", message: "Unexpected Error Occurred", isError: true);
    }
  }

  void addServiceapi({
    required String name,
    required String description,
    required String price,
    required String subCat,
    required int business,
    required List<String> imagePaths,
  }) async {
    try {
      Loader.show();
      List<File> imageFiles = imagePaths.map((path) => File(path)).toList();

      Map<String, dynamic> productData = {
        "name": name,
        "description": description,
        "price": price,
        "cat": subCat,
        "buisness": business,
        "images[]": imageFiles,
      };

      var response = await ApiService().post(
        "/users/services/",
        productData,
        isMultipart: true,
        useSession: true,
      );

      if (response.statusCode == 201) {
        print(productData);
        Loader.hide();
        CommonSnackbar.show(
            isError: false,
            title: "Success",
            message: "Product added successfully");
      } else {
        print(response);
        Loader.hide();
        CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Failed to add product",
        );
      }
    } catch (e) {
      Loader.hide();
      CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Something Unexpected Occurred!");
    }
  }
}
