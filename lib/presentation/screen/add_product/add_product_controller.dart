import 'dart:io';

import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';

class Product {
  String name, description, category;
  double price;
  String image;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });
}

class ProductController extends GetxController {
  var products = <Product>[].obs;
  final ApiService apiService = ApiService();

  void addProduct(Product product) {
    products.add(product);
  }

  Future<bool> addProductapi({
    required String name,
    required String description,
    required String price,
    required String subCat,
    required int business,
    required List<String> imagePaths,
  }) async {
    try {
      List<File> imageFiles = imagePaths.map((path) => File(path)).toList();

      Map<String, dynamic> productData = {
        "name": name,
        "description": description,
        "price": price,
        "sub_cat": subCat,
        "buisness": business,
        "images[]": imageFiles,
      };

      var response = await apiService.post(
        "/users/addproduct/",
        productData,
        isMultipart: true,
        useSession: true,
      );

      if (response.statusCode == 201) {
        Loader.hide();
        CommonSnackbar.show(
          isError: false,
          title: "Success",
          message: "Product added successfully",
        );
        return true; // API 调用成功
      } else {
        CommonSnackbar.show(
          isError: true,
          title: "Error",
          message: "Failed to add product",
        );
        return false; // API 调用失败
      }
    } catch (e) {
      CommonSnackbar.show(
        isError: true,
        title: "Error",
        message: "Something Unexpected Occurred!",
      );
      print(e);
      return false; // API 调用失败
    }
  }
}
