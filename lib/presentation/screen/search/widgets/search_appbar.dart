import 'package:brandsinfo/presentation/screen/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final SearchScreenController searchController = Get.find();

  SearchAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              // Only update the controller when the observable changes
              if (controller.text != searchController.searchQuery.value) {
                controller.text = searchController.searchQuery.value;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              }

              return TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  searchController.addSearch(value);
                },
              );
            }),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              searchController.searchQuery.value = '';
            },
          ),
        ],
      ),
    );
  }
}
