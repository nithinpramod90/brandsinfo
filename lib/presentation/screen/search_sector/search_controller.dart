import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/specific_cat/specific_cat_controller.dart';
import 'package:brandsinfo/presentation/screen/specific_cat/specific_cat_screen.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:get/get.dart';

class SearchSectorController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final response = await ApiService().get('/users/popular_gencats/');
      if (response is List) {
        categories.assignAll(response.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      CommonSnackbar.show(
          title: "Error", message: "Failed to load categories", isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addsecctor(String bid, String cid) async {
    try {
      Loader.show();
      final response = await ApiService().post(
        '/users/add_bgencats/',
        {
          "bid": bid,
          "cid": cid,
        },
        useSession: true,
      );
      if (response.statusCode == 200) {
        Loader.hide();
        final SpecificSectorController controller =
            Get.put(SpecificSectorController(), permanent: true);

        controller.fetchCategories(cid, bid); // Fetch data before navigating
        Get.to(() => SpecificCatScreen(bid: bid, cid: cid));
      } else {
        Loader.hide();

        CommonSnackbar.show(
            title: "Error", message: "Unexpted Error occured", isError: true);
      }
    } catch (e) {
      Loader.hide();
      print(e);
      CommonSnackbar.show(
          title: "Error", message: "Unexpted Error occured", isError: true);
    }
  }

  void searchCategory(String query) async {
    if (query.isEmpty) {
      isSearching(false);
      searchResults.clear();
      return;
    }

    try {
      isLoading(true);
      isSearching(true);
      final response =
          await ApiService().get('/users/search_gencats/?q=$query');
      if (response is List) {
        searchResults.assignAll(response.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      // CommonSnackbar.show(
      //     title: "Error", message: "Failed to load categories", isError: true);
    } finally {
      isLoading(false);
    }
  }
}
