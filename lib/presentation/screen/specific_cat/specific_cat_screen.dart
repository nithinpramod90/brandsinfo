import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'specific_cat_controller.dart';

class SpecificCatScreen extends StatelessWidget {
  final String bid;
  final String cid;
  final SpecificSectorController controller =
      Get.find<SpecificSectorController>();

  SpecificCatScreen({super.key, required this.bid, required this.cid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Search for Your Sector',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                List categoriesToShow = controller.isSearching.value
                    ? controller.searchResults
                    : controller.categories;

                if (categoriesToShow.isEmpty) {
                  return const Center(child: Text("No categories found"));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: categoriesToShow.length,
                  itemBuilder: (context, index) {
                    final category = categoriesToShow[index];
                    final categoryId = category['id'].toString();

                    // Use Obx here to reactively update each grid item
                    return Obx(() {
                      final isSelected =
                          controller.selectedCategories.contains(categoryId);

                      return GestureDetector(
                        onTap: () {
                          controller.toggleCategorySelection(categoryId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xffFF750C)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected ? Color(0xffFF750C) : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              category['cat_name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Color(0xffFF750C)
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white // Dark mode color
                                        : Colors.black, // Light mode color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: controller.selectedCategories.isEmpty
                      ? null
                      : () => controller.addsecctor(bid),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF750C),
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    "Add Selected Sectors",
                    style: TextStyle(
                        color: controller.selectedCategories.isEmpty
                            ? Colors.black45
                            : Colors.white,
                        fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
