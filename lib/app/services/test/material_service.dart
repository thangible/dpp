import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/material/material.dart';

class MaterialService {
  static late final List<Material> materials;
  static late final Map<String, Material> materialMap;

  static Future<void> init() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/materials/materials.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      materials =
          jsonList
              .map((e) => Material.fromJson(e as Map<String, dynamic>))
              .toList();
    } catch (e) {
      print('Error loading materials.json: $e');
      materials = [];
    }
    materialMap = {for (var material in materials) material.id: material};
  }

  static Material? getMaterialById(String id) => materialMap[id];

  static List<Material> getAllMaterials() => materialMap.values.toList();

  static List<String> get materialIds => materialMap.keys.toList();
}
