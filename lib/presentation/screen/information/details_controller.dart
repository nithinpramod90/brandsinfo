import 'dart:io';
import 'package:brandsinfo/presentation/screen/information/bottom_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/businessinfo/businessinfo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Business model
class Business {
  final int id;
  String name;
  String description;
  String buildingName;
  String locality;
  String city;
  String state;
  String pincode;
  String opensAt;
  String closesAt;
  String since;
  String instagramLink;
  String facebookLink;
  String webLink;
  String xLink;
  String youtubeLink;
  String whatsappNumber;
  String inchargeNumber;
  String image;
  String email;
  String managerName;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.buildingName,
    required this.locality,
    required this.city,
    required this.state,
    required this.pincode,
    required this.opensAt,
    required this.closesAt,
    required this.since,
    required this.instagramLink,
    required this.facebookLink,
    required this.webLink,
    required this.xLink,
    required this.youtubeLink,
    required this.whatsappNumber,
    required this.inchargeNumber,
    required this.image,
    required this.email,
    required this.managerName,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      buildingName: json['building_name'] ?? '',
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      opensAt: json['opens_at'] ?? '',
      closesAt: json['closes_at'] ?? '',
      since: json['since'] ?? '',
      instagramLink: json['instagram_link'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      webLink: json['web_link'] ?? '',
      xLink: json['x_link'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      inchargeNumber: json['incharge_number'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      managerName: json['manager_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'building_name': buildingName,
      'locality': locality,
      'city': city,
      'state': state,
      'pincode': pincode,
      'opens_at': opensAt,
      'closes_at': closesAt,
      'since': since,
      'instagram_link': instagramLink,
      'facebook_link': facebookLink,
      'web_link': webLink,
      'x_link': xLink,
      'youtube_link': youtubeLink,
      'whatsapp_number': whatsappNumber,
      'incharge_number': inchargeNumber,
      'image': image,
      'email': email,
      'manager_name': managerName,
    };
  }
}

class DetailsController extends GetxController {
  final Rx<Business?> business = Rx<Business?>(null);
  final RxBool isLoading = true.obs;
  final RxString currentEditing = ''.obs;
  final TextEditingController editController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final RxString imagePath = ''.obs;
  final RxBool isUploading = false.obs;

  Future<void> fetchBusinessData(String bid) async {
    try {
      isLoading.value = true;
      // Fetch new business data
      final response =
          await ApiService().get("/users/buisnesses_short/?bid=$bid");
      final businessData =
          response; // Assuming response is directly the business data
      business.value = Business.fromJson(businessData);
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to load business data");
    } finally {
      isLoading.value = false;
    }
  }

  void startEditing(String field, String currentValue) {
    currentEditing.value = field;
    editController.text = currentValue;
  }

  void cancelEditing() {
    currentEditing.value = '';
    editController.clear();
  }

  Future<void> saveField(String field) async {
    if (business.value == null) return;

    try {
      // Update the field in the local business object
      switch (field) {
        case 'name':
          business.value!.name = editController.text;
          break;
        case 'description':
          business.value!.description = editController.text;
          break;
        case 'buildingName':
          business.value!.buildingName = editController.text;
          break;
        case 'locality':
          business.value!.locality = editController.text;
          break;
        case 'city':
          business.value!.city = editController.text;
          break;
        case 'state':
          business.value!.state = editController.text;
          break;
        case 'pincode':
          business.value!.pincode = editController.text;
          break;
        case 'email':
          business.value!.email = editController.text;
          break;
        case 'managerName':
          business.value!.managerName = editController.text;
          break;
        case 'whatsappNumber':
          business.value!.whatsappNumber = editController.text;
          break;
        case 'inchargeNumber':
          business.value!.inchargeNumber = editController.text;
          break;
        // Added cases for previously read-only fields
        case 'since':
          business.value!.since = editController.text;
          break;
        case 'opensAt':
          business.value!.opensAt = editController.text;
          break;
        case 'closesAt':
          business.value!.closesAt = editController.text;
          break;
        case 'webLink':
          business.value!.webLink = editController.text;
          break;
        case 'instagramLink':
          business.value!.instagramLink = editController.text;
          break;
        case 'facebookLink':
          business.value!.facebookLink = editController.text;
          break;
        case 'xLink':
          business.value!.xLink = editController.text;
          break;
        case 'youtubeLink':
          business.value!.youtubeLink = editController.text;
          break;
      }
      final controller = Get.find<BusinessinfoController>();
      final String bid = controller.bid.value;
      // Call API to update the field
      await ApiService().patch(
        "/users/buisnessesedit/$bid/",
        {field: editController.text},
      );
      fetchBusinessData(bid);
      Get.snackbar("Success", "Field updated successfully");
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to update field");
    } finally {
      cancelEditing();
      business.refresh();
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        // Upload the image immediately
        uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  // Image upload function
  Future<void> uploadImage() async {
    if (imagePath.value.isEmpty) return;

    try {
      isUploading.value = true;

      // Get the business ID
      final controller = Get.find<BusinessinfoController>();
      final String bid = controller.bid.value;

      // Create a FormData instance using Dio's FormData
      final File imageFile = File(imagePath.value);
      final String fileName = imageFile.path.split('/').last;

      // Use Dio's FormData.fromMap instead of Get's FormData
      dio.FormData formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // Call API to upload the image
      final response = await ApiService().patchWithFormData(
        "/users/buisnessesedit/$bid/",
        formData,
      );

      // Update the business image URL
      if (response.data['image'] != null) {
        business.value!.image = response.data['image'];
        fetchBusinessData(bid);
      }

      Get.snackbar("Success", "Image uploaded successfully");
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar("Error", "Failed to upload image");
    } finally {
      isUploading.value = false;
      imagePath.value = '';
    }
  }
}
