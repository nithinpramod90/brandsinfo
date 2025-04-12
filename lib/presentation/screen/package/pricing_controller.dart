import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/package/pricing_model.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var plans = <Plan>[].obs;
  var selectedPlanIndex = 0.obs;
  var selectedVariantIndex = RxMap<int, int>({});

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading(true);
      final response = await _apiService.get('/users/plans/');
      final List<dynamic> plansJson = response;
      plans.value =
          plansJson.map((planJson) => Plan.fromJson(planJson)).toList();

      // Initialize selected variant for each plan (default to first variant)
      for (int i = 0; i < plans.length; i++) {
        if (plans[i].variants.isNotEmpty) {
          selectedVariantIndex[i] = 0;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load plans: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  void selectVariant(int planIndex, int variantIndex) {
    selectedVariantIndex[planIndex] = variantIndex;
  }

  PlanVariant? getSelectedVariant(int planIndex) {
    if (plans.isEmpty || plans.length <= planIndex) return null;
    if (plans[planIndex].variants.isEmpty) return null;

    final variantIndex = selectedVariantIndex[planIndex] ?? 0;
    if (plans[planIndex].variants.length <= variantIndex) return null;

    return plans[planIndex].variants[variantIndex];
  }
}
