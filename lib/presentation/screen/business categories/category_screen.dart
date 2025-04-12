import 'package:brandsinfo/presentation/screen/add%20business%20category/add_category_screen.dart';
import 'package:brandsinfo/presentation/screen/business%20categories/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessCategoriesScreen extends StatelessWidget {
  final String businessId;

  BusinessCategoriesScreen({Key? key, required this.businessId})
      : super(key: key);

  final BusinessCategoriesController controller =
      Get.put(BusinessCategoriesController());

  @override
  Widget build(BuildContext context) {
    // Fetch categories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCategories(businessId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Categories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Please Retry'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchCategories(businessId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.categories.isEmpty) {
          return const Center(
            child: Text('No categories found'),
          );
        }

        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return ListTile(
              title: Text(category.catName),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.deleteCategory(category.id);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final List<String> selectedCategoryIds =
              await Get.to(() => AddCategoryScreen(bid: businessId));
          if (selectedCategoryIds != null && selectedCategoryIds.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.fetchCategories(businessId);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
