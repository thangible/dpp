// filepath: lib/app/services/base_client.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dpp/app/data_model/api/generic_submodel.dart';

class BaseClient {

  /// Reads a JSON file from assets and returns parsed AasResponse
  Future<AasResponse> loadJsonFromAssets(String jsonPath) async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(jsonPath);
      
      // Parse the JSON string to Map
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convert to AasResponse object
      final AasResponse aasResponse = AasResponse.fromJson(jsonData);
      
      return aasResponse;
    } catch (e) {
      throw Exception('Failed to load JSON from $jsonPath: $e');
    }
  }

  /// Alternative method that returns the raw JSON data as Map
  Future<Map<String, dynamic>> loadRawJsonFromAssets(String jsonPath) async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      return json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load raw JSON from $jsonPath: $e');
    }
  }
}
