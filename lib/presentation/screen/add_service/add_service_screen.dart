import 'dart:io';

import 'package:brandsinfo/presentation/screen/add_service/add_service_controller.dart';
import 'package:brandsinfo/presentation/screen/search_sector/search_sector_screen.dart';
import 'package:brandsinfo/presentation/screen/servicces/service_screen.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/presentation/widgets/custom_textfield.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/imagepicker/image_picker_controller.dart';
import 'package:brandsinfo/widgets/imagepicker/image_picker_widget.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen(
      {super.key, required this.business, required this.service});
  final int business;
  final bool service;
  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final ServicesController servicesController = Get.put(ServicesController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController tittleController = TextEditingController();

  final TextEditingController descController = TextEditingController();
  bool showtittle = false;

  // File? _image;

  // final picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  List<File> selectedImages = [];
  late ImagePickerWidget imagePickerWidget;

  void _addService() async {
    // Make the method async
    if (_formKey.currentState!.validate() &&
        imagePickerController.selectedImages.isNotEmpty) {
      print("validated");

      // Await the API result
      bool isSuccess = await servicesController.addServiceapi(
        name: nameController.text,
        description: descController.text,
        price: priceController.text,
        subCat: servicesController.categoryId.value.toString(),
        business: widget.business,
        imagePaths:
            imagePickerController.selectedImages.map((e) => e.path).toList(),
      );

      if (isSuccess) {
        // Only add to local state if API succeeded
        servicesController.addProduct(
          Services(
            name: nameController.text,
            price: double.parse(priceController.text),
            description: descController.text,
            image: imagePickerController.selectedImages
                .map((e) => e.path)
                .toList()
                .join(','),
            categoryId: servicesController.categoryId.value,
          ),
        );

        // Clear form and images
        nameController.clear();
        priceController.clear();
        descController.clear();
        imagePickerController.clearImages();
      }
    } else {
      if (imagePickerController.selectedImages.isEmpty) {
        CommonSnackbar.show(
            title: "Error", message: "Add Image and Continue", isError: true);
      }
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
                        'Add Service',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      CommonSizedBox.h10,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              height: 60,
                              controller: tittleController,
                              hintText: "Enter Service Title",
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: SizedBox(
                              width: 120,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (tittleController.text.isNotEmpty &&
                                      servicesController.showTitle.value ==
                                          false) {
                                    // servicesController.toggleTitle(true);
                                    servicesController.addServiceCategory(
                                      tittleController.text,
                                      widget.business.toString(),
                                    );
                                  } else {
                                    if (tittleController.text.isEmpty) {
                                      CommonSnackbar.show(
                                          title: "Info",
                                          message: "Please add a tittle",
                                          isError: false);
                                    } else {
                                      CommonSnackbar.show(
                                          title: "Error",
                                          message: "Tittle Already added",
                                          isError: true);
                                    }
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
                                child: Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Obx(() => servicesController.showTitle.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    servicesController.toggleTitle(false);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.add_circled),
                                      CommonSizedBox.w5,
                                      Text("Add New Title"),
                                    ],
                                  ),
                                ),
                                Text(
                                    "Services will be added under this title:  ${tittleController.text}")
                              ],
                            )
                          : SizedBox.shrink()),
                      CommonSizedBox.h10,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: nameController,
                              hintText: "Service Name",
                              validator: (value) => value!.isEmpty
                                  ? 'Product name is required'
                                  : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: CustomTextField(
                              controller: priceController,
                              hintText: "Price",
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
                              controller: descController,
                              hintText: "Service Decription",
                              validator: (value) => value!.isEmpty
                                  ? 'Category is required'
                                  : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: ImagePickerWidget(),
                          )
                        ],
                      ),
                      CommonSizedBox.h30,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (servicesController.showTitle.value == true) {
                              _addService();
                            } else {
                              CommonSnackbar.show(
                                title: "Info",
                                message: "Please add a tittle",
                                isError: false,
                              );
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
                            'Add Service',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      CommonSizedBox.h20,
                      Obx(() => servicesController.serviceCategories.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: servicesController.serviceCategories
                                  .map((category) {
                                // Get services under this category
                                var categoryServices = servicesController
                                    .service
                                    .where((service) =>
                                        service.categoryId == category["id"])
                                    .toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " ${category['name']}", // Title text
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    CommonSizedBox.h10,
                                    categoryServices.isNotEmpty
                                        ? SizedBox(
                                            height: 120,
                                            width: double.infinity,
                                            child: CarouselSlider(
                                              options: CarouselOptions(
                                                viewportFraction: 0.85,
                                                height: 120.0,
                                                enableInfiniteScroll: false,
                                              ),
                                              items: categoryServices
                                                  .map((product) {
                                                String firstImagePath =
                                                    product.image.contains(',')
                                                        ? product.image
                                                            .split(',')
                                                            .first
                                                            .trim()
                                                        : product.image;
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black26
                                                          : Colors
                                                              .indigo.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 90,
                                                          width: 100,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: firstImagePath
                                                                        .isNotEmpty &&
                                                                    File(firstImagePath)
                                                                        .existsSync()
                                                                ? Image.file(
                                                                    File(
                                                                        firstImagePath),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: 100,
                                                                  )
                                                                : Image.asset(
                                                                    'assets/images/logo.png', // Default placeholder
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: 100,
                                                                  ),
                                                          ),
                                                        ),
                                                        CommonSizedBox.w10,
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(product.name,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge),
                                                            Text(
                                                                product
                                                                    .description,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium),
                                                            Text(
                                                                "Price: ₹ ${product.price}",
                                                                style: Theme.of(
                                                                        context)
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
                                        : Text(
                                            "No services added under this title"),
                                  ],
                                );
                              }).toList(),
                            )
                          : Container()),
                      CommonSizedBox.h30,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.service == true) {
                              Get.off(() => ServiceScreen(
                                  bid: widget.business.toString()));
                            } else {
                              Get.off(() => SearchSectorScreen(
                                    bid: widget.business,
                                  ));
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
}
