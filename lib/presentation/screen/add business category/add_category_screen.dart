import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  final String bid; // Business ID passed to the screen

  AddCategoryScreen({Key? key, required this.bid}) : super(key: key);

  final AddCategoryController controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    // Set the business ID in the controller
    controller.setBid(bid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search for categories',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => controller.isSearching.value
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const SizedBox.shrink()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                if (value.length > 2) {
                  controller.searchCategories(value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Selected Categories Section
            Obx(() => controller.selectedCategories.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Categories:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.selectedCategories
                            .map((category) => Chip(
                                  label: Text(category.catName),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () =>
                                      controller.removeCategory(category.id),
                                ))
                            .toList(),
                      ),
                      const Divider(height: 24),
                    ],
                  )
                : const SizedBox.shrink()),

            // Category Suggestions List
            Obx(
              () => controller.isSearching.value &&
                      controller.suggestions.isEmpty
                  ? const Center(child: Text('Searching...'))
                  : controller.suggestions.isEmpty
                      ? const Center(
                          child: Text(
                              'No categories found. Try searching with different keywords.'))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: controller.suggestions.length,
                            itemBuilder: (context, index) {
                              final category = controller.suggestions[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(category.catName),
                                  // trailing: Obx(() => controller
                                  //         .isCategorySelected(category.id)
                                  //     ? const Icon(Icons.check_circle,
                                  //         color: Colors.green)
                                  //     : const Icon(Icons.add_circle_outline)),
                                  onTap: () {
                                    controller.selectCategory(category);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: controller.selectedCategories.isNotEmpty
                  ? () => controller.addCategory()
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isAdding.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Add Categories',
                      style: TextStyle(fontSize: 16)),
            ),
          )),
    );
  }
}
