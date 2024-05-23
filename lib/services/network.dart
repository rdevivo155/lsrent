import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  final String baseUrl = "https://api.example.com";

  Future<dynamic> fetchData(String endpoint, String token) async {
    try {
      var response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}