import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/business_switch.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/category_container.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/circle_score.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/detais_container.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/keywords_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/offerenquiry.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/products_widget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/profile_imagewidget.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/total_visits.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/widgets/upgrade_banner.dart';
import 'package:brandsinfo/presentation/screen/package/pricing_screen.dart';
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

  // Check if the feature is available in the current plan
  bool _isFeatureAvailable(dynamic plan, String featureName) {
    if (plan == null) return false;

    // Safely access the feature
    try {
      return plan[featureName] == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessinfoController>();

    return Obx(() {
      // Get the business info and analytics data
      final business = controller.businessInfo.value;
      final analytics = controller.businessData['analytics'];

      // Check if analytics is a map
      final isAnalyticsMap = analytics is Map;

      // Safely extract plan information
      final plan = business['plan'];
      final isPremiumPlan = plan != null &&
          plan['id'] != null &&
          plan['id'] != 7 &&
          plan['plan_name'] != 'Default Plan';

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
                              score: int.parse(
                                  business['score']?.toString() ?? '0'),
                              bid: business['id'].toString(),
                            ),
                            CommonSizedBox.h20,

                            // Plan info banner - shown only if not on premium plan
                            if (!isPremiumPlan)
                              UpgradeBanner(
                                planName: plan != null
                                    ? (plan['plan_name']?.toString() ??
                                        'Free Plan')
                                    : 'Free Plan',
                                onUpgrade: () {
                                  // Handle upgrade action
                                  _showUpgradeDialog(context);
                                },
                              ),
                            CommonSizedBox.h30,

                            // Analytics or Details based on tab selection
                            isAnalyticsSelected
                                ? Column(
                                    children: [
                                      // Always show visits, but indicate if premium feature
                                      Stack(
                                        children: [
                                          EnhancedEmeraldBlurCard(
                                            bid: business['id'].toString(),
                                            title: "Total Visits",
                                            value: business['no_of_views']
                                                    ?.toString() ??
                                                '0',
                                            percentage: (isAnalyticsMap &&
                                                    analytics[
                                                            'profile_views_progress'] !=
                                                        null)
                                                ? analytics[
                                                        'profile_views_progress']
                                                    .toString()
                                                : "0.0",
                                            subtitle:
                                                "People viewed your business",
                                            isPositive: true,
                                          ),
                                          if (!isPremiumPlan)
                                            Positioned.fill(
                                              child: Material(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {
                                                    // Show upgrade dialog or navigate to upgrade page
                                                    _showUpgradeDialog(context);
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Text(
                                                        "Premium Feature",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      CommonSizedBox.h20,

                                      // Business Category Container with premium indicator if needed
                                      Stack(
                                        children: [
                                          BusinessCategoryContainer(
                                            bid: business['id'].toString(),
                                          ),
                                          if (!isPremiumPlan)
                                            Positioned.fill(
                                              child: Material(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {
                                                    _showUpgradeDialog(context);
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Text(
                                                        "Premium Feature",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      CommonSizedBox.h20,

                                      // Keywords widget with proper type checking
                                      if (isAnalyticsMap &&
                                          analytics['keywords'] != null &&
                                          analytics['keywords'] is Iterable)
                                        Stack(
                                          children: [
                                            KeywordsWidget(
                                              sa: (isAnalyticsMap &&
                                                      analytics['searched'] !=
                                                          null)
                                                  ? analytics['searched']
                                                      .toString()
                                                  : 'N/A',
                                              keywords: List<dynamic>.from(
                                                  analytics['keywords']),
                                            ),
                                            if (!isPremiumPlan)
                                              Positioned.fill(
                                                child: Material(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showUpgradeDialog(
                                                          context);
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Center(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12,
                                                                vertical: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                          "Premium Feature",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      else
                                        // Placeholder for keywords
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Keywords & Search Analytics",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  if (!isPremiumPlan)
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        _showUpgradeDialog(
                                                            context);
                                                      },
                                                      icon: Icon(Icons.lock,
                                                          size: 16),
                                                      label: Text("Upgrade"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Colors
                                                            .green.shade700,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 6),
                                                        minimumSize: Size(0, 0),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Unlock insights about how customers find your business",
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      CommonSizedBox.h50,

                                      // Offers and Enquiries
                                      Offerenquiry(
                                        bid: business['id'].toString(),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      GlassmorphicDetailsContainer(
                                        phone: business['incharge_number']
                                                ?.toString() ??
                                            '',
                                        email:
                                            business['email']?.toString() ?? '',
                                        address:
                                            "${business['building_name'] ?? ''},${business['locality'] ?? ''},${business['city'] ?? ''},${business['state'] ?? ''}",
                                        opens:
                                            business['opens_at']?.toString() ??
                                                'Not specified',
                                        close:
                                            business['closes_at']?.toString() ??
                                                'Not specified',
                                      ),
                                      CommonSizedBox.h20,

                                      // Products and Services
                                      // if (isPremiumPlan)
                                      ProductServiceSelector(
                                        businessType: business['buisness_type'],
                                        onProductTap: () {
                                          Get.to(() => ProductScreen(
                                              bid: business['id'].toString()));
                                        },
                                        onServiceTap: () {
                                          Get.to(() => ServiceScreen(
                                              bid: business['id'].toString()));
                                        },
                                      )
                                      // else
                                      //   // Limited version for non-premium users
                                      //   LimitedProductsPreview(
                                      //     products: controller.businessData[
                                      //                     'products'] !=
                                      //                 null &&
                                      //             controller.businessData[
                                      //                 'products'] is List
                                      //         ? List<
                                      //             Map<dynamic,
                                      //                 dynamic>>.from(controller
                                      //             .businessData['products'])
                                      //         : [],
                                      //     onUpgrade: () {
                                      //       _showUpgradeDialog(context);
                                      //     },
                                      //   ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),

                    // Always show the toggle switch
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
      );
    });
  }

  // Show upgrade dialog
  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Upgrade Your Plan"),
        content: Text(
          "This feature is available with our premium plans. Upgrade now to access analytics, enhanced visibility, and more!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Not Now"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to subscription screen
              Get.to(() => SubscriptionPlansScreen());
            },
            child: Text("Upgrade Now"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Modified LimitedProductsPreview to handle dynamic type properly
class LimitedProductsPreview extends StatelessWidget {
  final List<Map<dynamic, dynamic>> products;
  final VoidCallback onUpgrade;

  const LimitedProductsPreview({
    Key? key,
    required this.products,
    required this.onUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Products Preview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: onUpgrade,
              child: Text("Upgrade"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        CommonSizedBox.h10,
        Container(
          height: 150,
          child: products.isEmpty
              ? Center(child: Text("No products available"))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length > 2 ? 2 : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productImages = product['product_images'];
                    final hasImages = productImages != null &&
                        productImages is List &&
                        productImages.isNotEmpty;

                    return Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: hasImages
                                ? Image.network(
                                    '${ApiConstants.apiurl}${(product['product_images'][0]['image'])}',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: Icon(Icons.image_not_supported),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 100,
                                    color: Colors.grey.shade300,
                                    child: Icon(Icons.image_not_supported),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product['name']?.toString() ?? 'Unknown',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (products.length > 2)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Upgrade to view all products",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
