import 'dart:io';
import 'package:brandsinfo/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class EditServiceController extends ChangeNotifier {
  final int serviceId;
  final ApiService apiService = ApiService();
  final String bid;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // State variables
  bool isLoading = true;
  String? error;
  String categoryName = '';
  List<Map<String, dynamic>> serviceImages = [];
  List<File> newImages = [];
  EditServiceController({required this.serviceId, required this.bid});

  Future<void> fetchServiceDetails() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final responseList = await apiService.get('/users/services/?bid=$bid');

      final service = (responseList as List).firstWhere(
        (item) => item['id'] == serviceId,
        orElse: () => throw Exception('Service not found'),
      );

      nameController.text = service['name'] ?? '';
      priceController.text = (service['price'] ?? '0').toString();
      descriptionController.text = service['description'] ?? '';
      categoryName = service['cat_name'] ?? '';

// Parse service images
      serviceImages = [];
      if (service['service_images'] is List) {
        for (var img in service['service_images']) {
          if (img['image'] != null && img['id'] != null) {
            serviceImages.add({'id': img['id'], 'image': img['image']});
          }
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void addNewImage(File image) {
    newImages.add(image);
    notifyListeners();
  }

  void removeNewImage(int index) {
    if (index >= 0 && index < newImages.length) {
      newImages.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> deleteImage(String imagePath, int index, int imageid) async {
    try {
      // Extract image ID from path or use other logic to get the correct image ID
      final parts = imagePath.split('/');
      final fileName = parts.last;
      final imageId =
          fileName.split('.').first; // This assumes filename format contains ID

      await apiService.delete('/users/dlt_service_img/$imageid/');

      // Remove from local list if API call succeeds
      serviceImages.removeAt(index);
      notifyListeners();
    } catch (e) {
      error = 'Failed to delete image: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> updateService() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Update service details
      final updateData = {
        'name': nameController.text,
        'price': priceController.text,
        'description': descriptionController.text,
      };

      await apiService.patch('/users/edt_service/$serviceId/', updateData);

      // Upload new images if any
      if (newImages.isNotEmpty) {
        await _uploadNewImages();
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _uploadNewImages() async {
    // This uses a more direct approach to handle file uploads since we need multipart
    try {
      for (var imageFile in newImages) {
        final uri = Uri.parse('${ApiConstants.apiurl}/users/add_service_img/');

        var request = http.MultipartRequest('POST', uri);

        // Add the authorization headers that your API service uses
        request.headers.addAll(await apiService.getHeaders());

        // Add service ID
        request.fields['sid'] = serviceId.toString();

        // Add file
        var stream =
            http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'images[]',
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);

        // Send the request
        await request.send();
      }
    } catch (e) {
      throw Exception('Failed to upload images: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
