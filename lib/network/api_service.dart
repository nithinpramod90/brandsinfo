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
      String? sessionId = await SecureStorage.getSessionId();
      final response = await _dio.get(
        endpoint,
        options: Options(headers: {"Authorization": "Bearer $sessionId"}),
      );
      print('apiresponse:${response.data}');
      return response.data;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<dynamic> postWithFormData(String endpoint, FormData formData) async {
    try {
      // Print for debugging
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files.length} files');

      final response = await _dio.post(
        '${ApiConstants.apiurl}$endpoint',
        data: formData,
        options: Options(
          headers: await getHeaders(includeContentType: false),
          // Add progress tracking if needed
          // onSendProgress: (int stokenent, int total) {
          //   print('Sent: $sent / Total: $total');
          // },
        ),
      );
      return response.data;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, String>> getHeaders(
      {bool includeContentType = true}) async {
    String? sessionId = await SecureStorage.getSessionId();

    // Get your authentication token or other headers
    final Map<String, String> headers = {
      "Authorization": "Bearer $sessionId",
    };

    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  // Error handling method
  void _handleError(dynamic error) {
    if (error is DioException) {
      print('Dio error: ${error.message}');
      print('Response data: ${error.response?.data}');
      print('Response status code: ${error.response?.statusCode}');
    } else {
      print('Unexpected error: $error');
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
      data.forEach((key, value) {
        if (value is String || value is int || value is double) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

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

  Future<Response> patch(String endpoint, Map<String, dynamic> data) async {
    try {
      String? sessionId = await SecureStorage.getSessionId();
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $sessionId",
            "Content-Type": "application/json",
          },
        ),
      );

      print('Patch response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      String? sessionId = await SecureStorage.getSessionId();
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
      print('Delete response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

extension ApiServiceExtension on ApiService {
  Future<Response> patchWithFormData(String endpoint, FormData formData) async {
    try {
      String? sessionId = await SecureStorage.getSessionId();
      final response = await _dio.patch(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $sessionId",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print('Patch with FormData response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
