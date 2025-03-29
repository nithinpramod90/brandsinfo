import 'package:brandsinfo/presentation/screen/search/search_controller.dart';
import 'package:brandsinfo/presentation/screen/search/widgets/recent_searchlist.dart';
import 'package:brandsinfo/presentation/screen/search/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final SearchScreenController searchController =
      Get.put(SearchScreenController());
  final TextEditingController textController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchAppBar(
              controller: textController,
            ),
            Expanded(
              child: Obx(() {
                return RecentSearchesList(
                  searches: searchController.recentSearches
                      .toList(), // ✅ Added `.toList()`
                  onTap: searchController.selectRecentSearch,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
