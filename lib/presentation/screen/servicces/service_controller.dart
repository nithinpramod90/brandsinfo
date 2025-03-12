import 'package:brandsinfo/network/api_service.dart';
import 'package:flutter/material.dart';

// Service model to parse the API response
class Service {
  final int id;
  final String cat;
  final String name;
  final double price;
  final String image;
  final int searched;
  final int buisness;

  Service({
    required this.id,
    required this.cat,
    required this.name,
    required this.price,
    required this.image,
    required this.searched,
    required this.buisness,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      cat: json['cat'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
      searched: json['searched'],
      buisness: json['buisness'],
    );
  }
}

// Controller for the service screen
class ServiceController extends ChangeNotifier {
  final String bid;
  List<Service> services = [];
  bool isLoading = false;
  String? error;

  ServiceController({required this.bid});

  // Fetch services from the API
  Future<void> fetchServices() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final apiService = ApiService();
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
      // await apiService.delete('/users/services/$serviceId/');
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
