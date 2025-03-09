import 'package:brandsinfo/presentation/screen/add_product/category_search_controller.dart';
import 'package:brandsinfo/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final CategorySearchController categoryController =
      Get.put(CategorySearchController());
  final Function(String) onCategorySelected;
  final Function(String) oncatid;

  ProductCategoryWidget(
      {super.key,
      required this.textEditingController,
      required this.onCategorySelected,
      required this.oncatid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          height: 50,
          hintText: "Product Category",
          controller: textEditingController,
          onChanged: (value) => categoryController.searchCategories(value),
        ),

        // Category Suggestions Dropdown
        Obx(() {
          if (categoryController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (categoryController.categoryList.isEmpty) {
            return SizedBox();
          }

          return Container(
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  var category = categoryController.categoryList[index];
                  return ListTile(
                    title: Text(category['name']),
                    onTap: () {
                      categoryController.categoryList.clear();
                      textEditingController.text = category['name'].toString();
                      oncatid(category['id'].toString());
                      onCategorySelected(category['name'].toString());
                      FocusScope.of(context).unfocus(); // Hide the keyboard
                    },
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
