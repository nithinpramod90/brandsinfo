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

  ProductCategoryWidget({
    super.key,
    required this.textEditingController,
    required this.onCategorySelected,
    required this.oncatid,
  });

  void _showCategorySelectionDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    // Initialize search with empty string to show all categories initially
    categoryController.searchCategories('');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: Text('Select Category'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search field
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) =>
                    categoryController.searchCategories(value),
              ),
              SizedBox(height: 10),

              // Categories list
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: Obx(() {
                    if (categoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (categoryController.categoryList.isEmpty) {
                      return Center(child: Text('No categories found'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryController.categoryList.length,
                      itemBuilder: (context, index) {
                        var category = categoryController.categoryList[index];
                        return ListTile(
                          title: Text(category['name']),
                          onTap: () {
                            // Clear category list
                            categoryController.categoryList.clear();

                            // Update text field and callback functions
                            textEditingController.text =
                                category['name'].toString();
                            oncatid(category['id'].toString());
                            onCategorySelected(category['name'].toString());

                            // Close dialog
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showCategorySelectionDialog(context),
          child: AbsorbPointer(
            child: CustomTextField(
              height: 50,
              hintText: "Product Category",
              controller: textEditingController,
              // suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
      ],
    );
  }
}
