import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/business_switch.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/circle_score.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/detais_container.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/keywords_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/offerenquiry.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/products_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_imagewidget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/total_visits.dart';
import 'package:brandsinfo/presentation/screen/products/products_screen.dart';
import 'package:brandsinfo/presentation/screen/servicces/service_screen.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessinfoScreen extends StatefulWidget {
  const BusinessinfoScreen({super.key});

  @override
  State<BusinessinfoScreen> createState() => _BusinessinfoScreenState();
}

class _BusinessinfoScreenState extends State<BusinessinfoScreen> {
  bool isAnalyticsSelected = true; // Default selection

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<BusinessinfoController>();
      controller.fetchBusinessData(); // 🔹 Fetch fresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessinfoController>();

    return Obx(() {
      // ignore: invalid_use_of_protected_member
      final business = controller.businessInfo.value;
      final analytics = controller.businessData['analytics'] ?? {};

      return Scaffold(
        extendBody: true, // Allows content to extend behind BottomAppBar
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          bottom:
                              80), // Add padding to prevent content from being hidden behind the button

                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileImagewidget(
                              image: business['image']?.toString() ?? '',
                              businessname:
                                  business['name']?.toString() ?? 'Unknown',
                              businesstype:
                                  business['buisness_type']?.toString() ??
                                      'N/A',
                              images: business['image_gallery'] ?? [],
                              bid: business['id'].toString(),
                            ),
                            CommonSizedBox.h20,
                            ProfileScoreWidget(
                              score: int.parse(business['score'] ?? '0'),
                              bid: business['id'].toString(),
                            ),
                            CommonSizedBox.h50,
                            isAnalyticsSelected
                                ? Column(
                                    children: [
                                      EnhancedEmeraldBlurCard(
                                        title: "Total Visits",
                                        value: business['no_of_views']
                                                ?.toString() ??
                                            '0',
                                        percentage:
                                            analytics['profile_views_progress']
                                                    ?.toString() ??
                                                "0.0",
                                        subtitle: "People viewed your business",
                                        isPositive: true,
                                      ),
                                      CommonSizedBox.h20,
                                      KeywordsWidget(
                                        sa: business['sa_rate']?.toString() ??
                                            'N/A',
                                        keywords: (analytics['keywords'] ?? [])
                                            as List<dynamic>,
                                      ),
                                      CommonSizedBox.h50,
                                      Offerenquiry(
                                        bid: business['id'].toString(),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      GlassmorphicDetailsContainer(
                                        phone:
                                            business['incharge_number'] ?? '',
                                        email: business['email'] ?? '',
                                        address:
                                            "${business['building_name']},${business['locality']},${business['city']},${business['state']}",
                                        opens: business['opens_at'] ?? '',
                                        close: business['closes_at'] ?? '',
                                      ),
                                      CommonSizedBox.h20,
                                      ProductServiceSelector(
                                          businessType:
                                              business['buisness_type'],
                                          onProductTap: () {
                                            Get.to(() => ProductScreen(
                                                bid:
                                                    business['id'].toString()));
                                          },
                                          onServiceTap: () {
                                            Get.to(() => ServiceScreen(
                                                bid:
                                                    business['id'].toString()));
                                          })
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 1,
                      child: BusinessSwitch(
                        isAnalyticsSelected: isAnalyticsSelected,
                        onToggle: (value) {
                          setState(() {
                            isAnalyticsSelected = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
        //   bottomNavigationBar:
        //       const ProductsAndServiceNavBar(), // Ensure it's a const widget
      );
    });
  }
}
