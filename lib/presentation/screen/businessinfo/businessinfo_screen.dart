import 'package:brandsinfo/presentation/screen/businessinfo/widgets/appbar.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/business_switch.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/keywords_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_imagewidget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/total_visits.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessinfoScreen extends StatelessWidget {
  const BusinessinfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final business = arguments['business'] ?? {};
    final products = arguments['products'] ?? [];
    final services = arguments['services'] ?? [];
    final analytics = arguments['analytics'] ?? {};

    return Scaffold(
      appBar: BusinessDetailAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImagewidget(
              image: business['image'] ?? '',
              businessname: business['name'] ?? 'Unknown',
              businesstype: business['buisness_type'] ?? 'N/A',
            ),
            CommonSizedBox.h20,
            ProfileWidget(
              score: business['score'] ?? '-',
            ),
            CommonSizedBox.h50,
            BusinessSwitch(),
            CommonSizedBox.h20,
            TotalVisitsCard(
              views: business['no_of_views'].toString() ?? "N/A",
              progress: analytics['profile_views_progress'],
              leads: analytics['leads'],
            ),
            CommonSizedBox.h20,
            KeywordsWidget(
              sa: business['sa_rate'],
              keywords: analytics['keywords'] ?? [],
            )
          ],
        ),
      ),
    );
  }
}
