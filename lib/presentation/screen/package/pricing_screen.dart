import 'package:brandsinfo/presentation/screen/package/pricing_controller.dart';
import 'package:brandsinfo/presentation/screen/package/pricing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  final PlanController controller = Get.put(PlanController());

  SubscriptionPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        if (controller.plans.isEmpty) {
          return const Center(
            child: Text(
              'No plans available',
              // style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [Color(0xFF121212), Color(0xFF0A1128)],
              // ),`
              ),
          child: Column(
            children: [
              // Plan selection cards
              _buildPlanCards(),

              // Selected plan features
              Expanded(
                child: Obx(() => _buildSelectedPlanFeatures()),
              ),

              // Purchase button
              _buildPurchaseButton(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPlanCards() {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.plans.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedPlanIndex.value == index;
            final plan = controller.plans[index];
            final selectedVariant = controller.getSelectedVariant(index);

            return GestureDetector(
              onTap: () => controller.selectPlan(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 16),
                width: 180,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plan.planName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'From ₹${_getLowestPrice(plan)}',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? Colors.transparent : Colors.orange,
                        ),
                      ),
                      child: Text(
                        isSelected ? 'SELECTED' : 'SELECT',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  int _getLowestPrice(Plan plan) {
    if (plan.variants.isEmpty) return 0;

    int lowestPrice = int.tryParse(plan.variants[0].price) ?? 0;
    for (var variant in plan.variants) {
      int currentPrice = int.tryParse(variant.price) ?? 0;
      if (currentPrice < lowestPrice) {
        lowestPrice = currentPrice;
      }
    }
    return lowestPrice;
  }

  Widget _buildSelectedPlanFeatures() {
    final selectedPlanIndex = controller.selectedPlanIndex.value;
    if (selectedPlanIndex >= controller.plans.length) return const SizedBox();

    final selectedPlan = controller.plans[selectedPlanIndex];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // Duration options
          _buildDurationOptions(selectedPlan, selectedPlanIndex),

          // Features list
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Plan Features',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildFeaturesList(selectedPlan)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOptions(Plan plan, int planIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Duration',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plan.variants.length,
              itemBuilder: (context, variantIndex) {
                final variant = plan.variants[variantIndex];

                return Obx(() {
                  final isSelected =
                      (controller.selectedVariantIndex[planIndex] ?? 0) ==
                          variantIndex;

                  return GestureDetector(
                    onTap: () =>
                        controller.selectVariant(planIndex, variantIndex),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${variant.duration}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Days',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${variant.price}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(Plan plan) {
    final features = [
      {'name': 'Profile Visit', 'enabled': plan.profileVisit},
      {'name': 'Chat', 'enabled': plan.chat},
      {'name': 'Image Gallery', 'enabled': plan.imageGallery},
      {'name': 'WhatsApp Chat', 'enabled': plan.whatsappChat},
      {'name': 'Video Gallery', 'enabled': plan.videoGallery},
      {'name': 'BI Verification', 'enabled': plan.biVerification},
      {
        'name': 'Search Priority',
        'enabled':
            plan.searchPriority1 || plan.searchPriority2 || plan.searchPriority3
      },
      {
        'name': 'Products & Service Visibility',
        'enabled': plan.productsAndServiceVisibility
      },
      {'name': 'Today\'s Offer', 'enabled': plan.todaysOffer},
      {'name': 'BI Certification', 'enabled': plan.biCertification},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: feature['enabled'] == true
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  feature['enabled'] == true ? Icons.check : Icons.close,
                  color: feature['enabled'] == true
                      ? Colors.orange
                      : Colors.redAccent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                feature['name'] as String,
                style: TextStyle(
                  color: feature['enabled'] == true
                      ? Colors.white
                      : Colors.white60,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        final selectedPlan =
            controller.plans[controller.selectedPlanIndex.value];
        final selectedVariant =
            controller.getSelectedVariant(controller.selectedPlanIndex.value);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${selectedVariant?.price}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle subscription
                Get.snackbar(
                  'Purchasing Plan',
                  'Activating ${selectedPlan.planName} for ${selectedVariant?.duration} days',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.all(16),
                  borderRadius: 10,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: Colors.orange.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: Size(double.infinity, 54),
              ),
              child: Text(
                'ACTIVATE NOW',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
