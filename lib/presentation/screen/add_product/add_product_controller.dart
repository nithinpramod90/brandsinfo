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

  void addProduct(Product product) {
    products.add(product);
  }
}
