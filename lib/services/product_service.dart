import 'dart:convert';
import 'package:flutter/services.dart';

class ProductService {
  static Future<Map<String, dynamic>> fetchProductSummaryData(String machineId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate DB/network delay
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allMachines = json.decode(response);
    return allMachines[machineId] ?? {};
  }
  static Future<List<String>> fetchMachineIds() async {
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allMachines = json.decode(response);
    return allMachines.keys.toList();
  }
}

