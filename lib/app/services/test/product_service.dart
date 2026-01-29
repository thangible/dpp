import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/api/base_aas_model.dart';

// import 'package:dpp/app/data_model/test/machine.dart';

class ProductService {
  static late final List<AasResponse>? responses;
  static late final Map<String, dynamic> manifestMap;
  static late final List<Product> products;
  static late final Map<String, Product> productMap;

  static Future<void> init() async {
    List<AasResponse> tempResponses = [];
    final String manifestContent = await rootBundle.loadString(
      'AssetManifest.json',
    );
    manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final jsonPaths =
        manifestMap.keys
            .where(
              (String key) =>
                  key.startsWith('assets/data/') && key.endsWith('.json'),
            )
            .toList();

    for (String path in jsonPaths) {
      print('Loading JSON from $path');
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        tempResponses.add(AasResponse.fromJson(jsonMap));
      } catch (e) {
        print('Error parsing $path: $e');
      }
    }

    responses = tempResponses;

    // Map product IDs to their corresponding Product objects
    products =
        responses?.map((response) {
          return Product.fromJson(response);
        }).toList() ??
        [];

    productMap = {for (var product in products) product.id: product};
  }

  static Product? getProductById(String id) {
    return productMap[id];
  }

  static List<Product> getAllProducts() {
    return productMap.values.toList();
  }

  static List<String> get productIds {
    return productMap.keys.toList();
  }
}
