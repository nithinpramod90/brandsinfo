import 'package:brandsinfo/model/business_model.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/dashboard/business_controller.dart';
import 'package:brandsinfo/presentation/screen/dashboard/widget/dashboard_grid.dart';
import 'package:brandsinfo/presentation/screen/dashboard/widget/add_business.dart';
import 'package:brandsinfo/presentation/screen/dashboard/widget/expand_business.dart';
import 'package:brandsinfo/presentation/widgets/custom_appbar.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final BusinessController controller = Get.put(BusinessController());
  final BusinessinfoController infocontroller =
      Get.put(BusinessinfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          if (controller.businessResponse.value == null) {
            return AppBar(title: const Text("")); // Default while loading
          }
          final userProfile = controller.businessResponse.value!.userProfile;
          return CustomAppBar(
            notificationCount: 3,
            name: userProfile.firstName,
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                CommonSizedBox.h10,
                Text("Loading ..."),
              ],
            ),
          );
        }

        if (controller.businessResponse.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Failed to load data"),
                CommonSizedBox.h10,
                TextButton(
                  onPressed: controller.fetchBusinesses,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final businesses = controller.businessResponse.value!.businesses;

        if (businesses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(
              child: AddBusiness(
                main: 'No Businesses Added',
                sub: 'Add your business to begin managing it.',
              ),
            ),
          );
        }

        // Replace CustomScrollView with a more optimized ListView implementation
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const ExpandBusiness(
                    main: 'Expand Your Business',
                    sub: 'Add another location or venture.',
                  ),
                  CommonSizedBox.h20,
                  Row(
                    children: const [
                      Text(
                        "Active Businesses",
                        textAlign: TextAlign.start,
                      ),
                      Spacer(),
                      Icon(CupertinoIcons.forward),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                // More efficient for scrolling performance
                physics: const AlwaysScrollableScrollPhysics(),
                addAutomaticKeepAlives: false, // Remove unnecessary keep-alives
                addRepaintBoundaries: true,
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  final business = businesses[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        infocontroller
                            .setBidAndNavigate(business.id.toString());
                      },
                      child: BusinessCard(
                        score: business.score,
                        name: business.name,
                        locality:
                            ("${business.locality}, ${business.city ?? ''}"),
                        views: business.noOfViews,
                        image: business.image,
                        plan: business.plan.planName,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
