import 'package:dio/dio.dart';

Future<Map<String, String>> fetchCityState(String pincode) async {
  try {
    final response =
        await Dio().get('https://api.postalpincode.in/pincode/$pincode');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data[0]['Status'] == 'Success') {
        return {
          'state': data[0]['PostOffice'][0]['State'],
          'district': data[0]['PostOffice'][0]['District'],
        };
      }
    }
  } catch (e) {
    print("Error fetching pincode data: $e");
  }
  return {'state': '', 'district': ''};
}
