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
      {bool useSession = false}) async {
    try {
      Map<String, String> headers = {};

      if (useSession) {
        String? sessionId = await SecureStorage.getSessionId();
        if (sessionId != null) {
          headers["Authorization"] = "Bearer $sessionId";
        }
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      print('omr req $response');
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
