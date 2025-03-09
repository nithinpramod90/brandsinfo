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
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          if (controller.businessResponse.value == null) {
            return AppBar(title: Text("Loading...")); // Default while loading
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
          return Center(child: CircularProgressIndicator());
        }

        if (controller.businessResponse.value == null) {
          return Center(child: Text("Failed to load data"));
        }

        final businesses = controller.businessResponse.value!.businesses;

        if (businesses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: AddBusiness(
                main: 'No Businesses Added',
                sub: 'Add your business to begin managing it.',
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ExpandBusiness(
                    main: 'Expand Your Business',
                    sub: 'Add another location or venture.',
                  ),
                  CommonSizedBox.h20,
                  Row(
                    children: [
                      Text(
                        "Active Businesses",
                        textAlign: TextAlign.start,
                      ),
                      Spacer(),
                      Icon(CupertinoIcons.forward)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  var business = businesses[index];
                  return GestureDetector(
                    onTap: () {
                      infocontroller.fetchBusinessData(business.id.toString());

                      print(business.id);
                      //business.id
                    },
                    child: BusinessCard(
                      score: business.score,
                      name: business.name,
                      locality:
                          ("${business.locality}, ${business.city ?? ''}"),
                      views: business.noOfViews,
                      image: business.image,
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
