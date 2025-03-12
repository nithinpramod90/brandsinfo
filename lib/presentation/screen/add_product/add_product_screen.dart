import 'package:brandsinfo/presentation/screen/add_product/add_product_controller.dart';
import 'package:brandsinfo/presentation/screen/add_product/widgets/product_category_widget.dart';
import 'package:brandsinfo/presentation/screen/add_service/add_service_screen.dart';
import 'package:brandsinfo/presentation/screen/products/products_screen.dart';
import 'package:brandsinfo/presentation/screen/search_sector/search_sector_screen.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/presentation/widgets/custom_textfield.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/imagepicker/image_picker_controller.dart';
import 'package:brandsinfo/widgets/imagepicker/image_picker_widget.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  final bool nav;
  final int id;
  final bool product;
  const AddProductScreen(
      {super.key, required this.nav, required this.id, required this.product});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.put(ProductController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String selectedCategory = '';
  String catid = '';

  List<File> selectedImages = [];
  late ImagePickerWidget imagePickerWidget;

  void _addProduct() {
    if (_formKey.currentState!.validate() &&
        imagePickerController.selectedImages.isNotEmpty) {
      Loader.show();
      productController.addProduct(Product(
        name: nameController.text,
        price: double.parse(priceController.text),
        description: descController.text,
        category: categoryController.text,
        image: imagePickerController.selectedImages
            .map((e) => e.path)
            .toList()
            .join(','), // Store image paths
      ));
      productController.addProductapi(
          name: nameController.text,
          description: descController.text,
          price: priceController.text,
          subCat: catid,
          business: widget.id,
          imagePaths:
              imagePickerController.selectedImages.map((e) => e.path).toList());
      // Clear input fields
      nameController.clear();
      priceController.clear();
      descController.clear();
      categoryController.clear();

      // Clear selected images from ImagePickerWidget
      imagePickerController.clearImages();
    } else {
      CommonSnackbar.show(
          title: "Error", message: "Add Image and Continue", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonSizedBox.h20,
                      CircularImageWidget(),
                      CommonSizedBox.h25,
                      Text(
                        'Add Product',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      CommonSizedBox.h25,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: nameController,
                              hintText: "Product Name",
                              validator: (value) => value!.isEmpty
                                  ? 'Product name is required'
                                  : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: CustomTextField(
                              controller: priceController,
                              hintText: "Product Price",
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Price is required' : null,
                            ),
                          ),
                        ],
                      ),
                      CommonSizedBox.h10,
                      Row(
                        children: [
                          Expanded(
                            child: ProductCategoryWidget(
                              textEditingController: categoryController,
                              oncatid: (cat) {
                                setState(() {
                                  catid = cat;
                                });
                              },
                              onCategorySelected: (category) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: ImagePickerWidget(),
                          ),
                        ],
                      ),
                      CommonSizedBox.h10,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              height: 80,
                              controller: descController,
                              hintText: "Description",
                              validator: (value) => value!.isEmpty
                                  ? 'Description is required'
                                  : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: SizedBox(
                              width: 120, // Adjust the width as needed
                              height: 80,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    _addProduct();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xffFF750C),
                                    // elevation: 5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(), // Add this line
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.add_circled_solid,
                                    color: Colors.white,
                                    size: 35,
                                  )),
                            ),
                          )
                        ],
                      ),
                      CommonSizedBox.h20,
                      Obx(() => productController.products.isNotEmpty
                          ? SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  height: 120.0,
                                  enableInfiniteScroll: false,
                                ),
                                items:
                                    productController.products.map((product) {
                                  // Handle multiple paths issue
                                  String firstImagePath = product.image
                                          .contains(',')
                                      ? product.image.split(',').first.trim()
                                      : product.image;

                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black26 // Dark mode color
                                          : Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 90,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child:
                                                  firstImagePath.isNotEmpty &&
                                                          File(firstImagePath)
                                                              .existsSync()
                                                      ? Image.file(
                                                          File(firstImagePath),
                                                          fit: BoxFit.cover,
                                                          height: 100,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/logo.png', // Default placeholder
                                                          fit: BoxFit.cover,
                                                          height: 100,
                                                        ),
                                            ),
                                          ),
                                          CommonSizedBox.w10,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(product.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                              Text(product.description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                              Text("Price: ₹ ${product.price}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Container()),
                      CommonSizedBox.h30,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (productController.products.isNotEmpty) {
                              if (widget.product == true) {
                                Get.back();
                                Get.off(() =>
                                    ProductScreen(bid: widget.id.toString()));
                              } else if (widget.nav == true) {
                                Get.off(() => AddServiceScreen(
                                      business: widget.id,
                                    ));
                              } else {
                                Get.off(() => SearchSectorScreen(
                                      bid: widget.id,
                                    ));
                              }
                            } else {
                              CommonSnackbar.show(
                                  isError: true,
                                  title: "Error",
                                  message: "Add a Product and Continue");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFF750C),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // List<String> getAllImages() {
  //   List<String> allImages = [];

  //   productController.products.forEach((product) {
  //     List<String> imageList =
  //         product.image.split(',').map((e) => e.trim()).toList();
  //     allImages.addAll(imageList);
  //   });

  //   return allImages;
  // }
}
