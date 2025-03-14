import 'dart:io';

import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/utils/secure_storage.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.apiurl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<dynamic> get(String endpoint) async {
    try {
      // Retrieve the session ID (token) from secure storage
      String? sessionId = await SecureStorage.getSessionId();

      // Add the Authorization header
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $sessionId",
          },
        ),
      );
      print('apiresponse:${response.data}');
      return response.data;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data,
      {bool useSession = false, bool isMultipart = false}) async {
    try {
      Map<String, String> headers = {
        "Content-Type":
            isMultipart ? "multipart/form-data" : "application/json",
      };

      if (useSession) {
        String? sessionId = await SecureStorage.getSessionId();
        if (sessionId != null) {
          headers["Authorization"] = "Bearer $sessionId";
        }
      }

      FormData formData = FormData();

      // Add text fields
      data.forEach((key, value) {
        if (value is String || value is int || value is double) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Attach images
      if (data.containsKey("images[]") && data["images[]"] is List<File>) {
        for (File file in data["images[]"]) {
          formData.files.add(MapEntry(
            "images[]",
            MultipartFile.fromFileSync(file.path,
                filename: file.path.split('/').last),
          ));
        }
      }

      final response = await _dio.post(
        endpoint,
        data: isMultipart ? formData : data,
        options: Options(headers: headers),
      );

      print('Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      // Retrieve the session ID (token) from secure storage
      String? sessionId = await SecureStorage.getSessionId();

      // Add the Authorization header
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $sessionId",
            "Content-Type": "application/json",
          },
        ),
      );
      print(response.statusCode);

      print('Delete response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
