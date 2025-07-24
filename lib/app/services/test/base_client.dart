// filepath: lib/app/services/base_client.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class BaseClient {
  final String _baseUrl = "https://api.example.com"; // Unused for mock data

  // GET request method
  Future<dynamic> get(String endpoint) async {
    // If the endpoint is "sample_endpoint", load from assets/mock_data.json.
    if (endpoint == "sample_endpoint") {
      try {
        final jsonString = await rootBundle.loadString("assets/mock_data.json");
        return jsonDecode(jsonString);
      } catch (e) {
        throw Exception("Failed to load mock data: $e");
      }
    }
    
    // Otherwise, perform a normal HTTP GET call (for production endpoints).
    final url = Uri.parse("$_baseUrl/$endpoint");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      rethrow;
    }
  }
}