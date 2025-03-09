import 'package:brandsinfo/presentation/screen/search_sector/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSectorScreen extends StatelessWidget {
  final int bid;
  final SearchSectorController controller = Get.put(SearchSectorController());

  SearchSectorScreen({super.key, required this.bid});
  void _addsearch(String cid) {
    print(bid);
    print(cid);
    controller.addsecctor(bid.toString(), cid);
  }

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
            TextField(
              onChanged: controller.searchCategory,
              decoration: InputDecoration(
                hintText: 'Search for Categories',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black26 // Dark mode color
                    : Colors.indigo.shade50, // Light mode color
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.isSearching.value) {
                  if (controller.searchResults.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }
                  // Show search results in a ListView
                  return ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final category = controller.searchResults[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.search,
                              color: Color(0xffFF750C)),
                          title: Text(category['name']),
                          onTap: () {
                            _addsearch(category['id'].toString());
                          },
                        ),
                      );
                    },
                  );
                } else {
                  // Show default categories in a GridView
                  if (controller.categories.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      return Card(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black26 // Dark mode color
                            : Colors.indigo.shade50, // Light mode color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.add_circled,
                              color: Color(0xffFF750C)),
                          title: Text(
                            category['name'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            _addsearch(category['id'].toString());
                          },
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
