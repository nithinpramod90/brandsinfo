import 'package:brandsinfo/presentation/screen/add_product/add_product_controller.dart';
import 'package:brandsinfo/presentation/screen/business/widgets/custom_dropdown.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/presentation/widgets/custom_textfield.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.put(ProductController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addProduct() {
    if (_formKey.currentState!.validate() && _image != null) {
      productController.addProduct(Product(
        name: nameController.text,
        price: double.parse(priceController.text),
        description: descController.text,
        category: categoryController.text,
        image: _image!.path,
      ));
      nameController.clear();
      priceController.clear();
      descController.clear();
      categoryController.clear();
      setState(() {
        _image = null;
      });
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
                            child: CustomTextField(
                              controller: categoryController,
                              hintText: "Product Category",
                              validator: (value) => value!.isEmpty
                                  ? 'Category is required'
                                  : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.cloud_upload,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                  CommonSizedBox.w5,
                                  Text("Add Image",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                          )
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
                                  onPressed: () {
                                    _addProduct();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
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
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black26 // Dark mode color
                                            : Colors.indigo.shade50,
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                              child: Image.file(
                                                  File(product.image),
                                                  fit: BoxFit.cover,
                                                  height: 100),
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
                                              Text("Price: \₹ ${product.price}",
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save and Continue',
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
}
