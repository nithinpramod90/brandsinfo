import 'package:brandsinfo/network/api_service.dart';
import 'package:flutter/material.dart';

class Service {
  final int id;
  final String cat;
  final String name;
  final double price;
  final String image;
  final int searched;
  final String description;
  final int buisness;

  Service({
    required this.id,
    required this.cat,
    required this.name,
    required this.price,
    required this.image,
    required this.searched,
    required this.description,
    required this.buisness,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    // Extract first image if available
    String imagePath = '';
    if (json['service_images'] is List && json['service_images'].isNotEmpty) {
      imagePath = json['service_images'][0]['image']?.toString() ?? '';
    }

    return Service(
      id: json['id'] ?? 0,
      cat: json['cat_name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _parsePrice(json['price']),
      image: imagePath,
      searched: json['searched'] ?? 0,
      description: json['description'] ?? "",
      buisness: json['buisness'] ?? 0,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }
}

// Controller for the service screen
class ServiceController extends ChangeNotifier {
  final String bid;
  List<Service> services = [];
  bool isLoading = false;
  String? error;

  ServiceController({required this.bid});
  final apiService = ApiService();

  // Fetch services from the API
  Future<void> fetchServices() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await apiService.get('/users/services/?bid=$bid');

      if (response is List) {
        services = response.map((item) => Service.fromJson(item)).toList();
      } else {
        error = 'Invalid response format';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete a service
  Future<void> deleteService(int serviceId) async {
    try {
      // Here you would make an API call to delete the service
      // For now, we'll just remove it from the local list
      services.removeWhere((service) => service.id == serviceId);
      notifyListeners();

      // In real implementation, you would call API to delete:
      await apiService.delete('/users/deleteservice/$serviceId/');
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
