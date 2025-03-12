import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/appbar.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/business_switch.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/detais_container.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/enquiryoffer_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/keywords_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/productsandservice_button.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_imagewidget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/total_visits.dart';
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
      final business = controller.businessInfo.value;
      final analytics = controller.businessData['analytics'] ?? {};

      return Scaffold(
        appBar: controller.isLoading.value
            ? AppBar(
                automaticallyImplyLeading: false,
                // title: const Text("Loading..."),
                // centerTitle: true,
              )
            : BusinessDetailAppBar(
                images: business['image_gallery'] ?? [],
              ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImagewidget(
                      image: business['image'] ?? '', // Ensure no null value
                      businessname: business['name'] ?? 'Unknown',
                      businesstype: business['buisness_type'] ?? 'N/A',
                    ),
                    CommonSizedBox.h20,
                    ProfileWidget(
                      score: business['score']?.toString() ??
                          '-', // Convert to String safely
                    ),
                    CommonSizedBox.h50,
                    BusinessSwitch(
                      isAnalyticsSelected: isAnalyticsSelected,
                      onToggle: (value) {
                        setState(() {
                          isAnalyticsSelected = value;
                        });
                      },
                    ),
                    CommonSizedBox.h20,
                    isAnalyticsSelected
                        ? Column(
                            children: [
                              TotalVisitsCard(
                                views:
                                    business['no_of_views']?.toString() ?? '0',
                                progress:
                                    analytics['profile_views_progress'] ?? 0.0,
                                leads: analytics['leads'] ?? 0,
                              ),
                              CommonSizedBox.h20,
                              KeywordsWidget(
                                sa: business['sa_rate'] ?? 'N/A',
                                keywords: analytics['keywords'] ?? [],
                              ),
                              CommonSizedBox.h20,
                              EnquiryofferWidget(),
                            ],
                          )
                        : Column(
                            children: [
                              GlassmorphicDetailsContainer(),
                              CommonSizedBox.h20,
                              ProductsandserviceButton(
                                type: business['buisness_type'],
                                bid: business['id'].toString(),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
      );
    });
  }
}
