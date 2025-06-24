import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data/product.dart';
import 'package:dpp/app/data/machine.dart';

class ProductService {
  static Future<Product> fetchProductData(String productId) async {
    // await Future.delayed(const Duration(seconds: 1)); // Simulate DB/network delay
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allProducts = json.decode(response);
    return Product.fromJson(allProducts[productId] as Map<String, dynamic>);
  }

  static Future<List<String>> fetchProductIds() async {
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allProducts = json.decode(response);
    return allProducts.keys.toList();
  }

  static Future<Machine> fetchMachineData(String productId) async {
    // await Future.delayed(const Duration(seconds: 1)); // Simulate DB/network delay
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allProducts = json.decode(response);
    return Machine.fromJson(allProducts[productId] as Map<String, dynamic>);
  }

  static Future<List<String>> fetchMachineIds() async {
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final Map<String, dynamic> allProducts = json.decode(response);
    return allProducts.keys.toList();
  }

}