import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';

// import 'package:dpp/app/data_model/test/machine.dart';

class ProductService {
  static late final List<AasResponse>? responses;
  static late final List<Product> products;
  static late final Map<String, Product> productMap;

  static Future<void> init() async {
    List<AasResponse> tempResponses = [];
    // AssetManifest.json is no longer bundled by Flutter (superseded by the
    // binary AssetManifest.bin) — use the AssetManifest API instead of
    // loading/parsing the old JSON file directly.
    final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(
      rootBundle,
    );

    final jsonPaths =
        manifest
            .listAssets()
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
    List<Product> mocks = mockProducts();
    products.addAll(mocks);
    productMap = {for (var product in products) product.id: product};
    print('ProductMap initialized with ${productMap.length} entries');
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

  /// For adding one product after the fact, e.g. from BasyxSyncService.
  /// Doesn't touch the bundled/mock ones.
  static void registerProduct(Product product) {
    productMap[product.id] = product;
    products.removeWhere((p) => p.id == product.id);
    products.add(product);
  }

  static List<Product> mockProducts() {
    return [
      Product(
        id: "Product A",
        energyUsed: 1500.0,
        co2Emissions: 300.0,
        processProgress: 100.0,
        lastUpdated: DateTime.now(),
        type: 'CNC Lathe',
        material: "R-PA12",
        materialId: "MAT-PA12-RGF30",
        manufacturer: 'IAPT',
        virginMaterial: 80.0,
        recycledMaterial: 20.0,
        imagePath: "assets/images/bauteil_image.png",
      ),
      Product(
        id: 'Product B',
        energyUsed: 2000.0,
        co2Emissions: 400.0,
        processProgress: 100.0,
        lastUpdated: DateTime.now(),
        type: '3D Printer',
        material: 'Plastic',
        materialId: "MAT-PETG-RC",
        manufacturer: 'PrintTech',
        virginMaterial: 70.0,
        recycledMaterial: 30.0,
        imagePath: "assets/images/bauteil_image3.png",
      ),
      Product(
        id: 'Product C',
        energyUsed: 850.0,
        co2Emissions: 120.0,
        processProgress: 62.0,
        lastUpdated: DateTime.now(),
        type: '3D Printer',
        material: 'PLA',
        materialId: "MAT-PLA-BIO",
        manufacturer: 'GreenFilament Co.',
        virginMaterial: 5.0,
        recycledMaterial: 95.0,
        imagePath: "No Image",
      ),
    ];
  }
}
