import 'package:hive_flutter/hive_flutter.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';

class HiveService {
  static const String _nameplateBoxName = 'nameplate';
  static Box? _nameplateBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _nameplateBox = await Hive.openBox(_nameplateBoxName);
  }

  /// Get the nameplate box
  static Box get nameplateBox {
    if (_nameplateBox == null) {
      throw Exception('HiveService not initialized. Call HiveService.init() first.');
    }
    return _nameplateBox!;
  }

  // --- Nameplate Operations ---

  /// Store submodel in Hive
  static Future<void> storeSubmodel(Submodel submodel) async {
    await nameplateBox.put('submodel', submodel.toJson());
  }

  /// Retrieve submodel from Hive
  static Submodel? getStoredSubmodel() {
    final submodelJson = nameplateBox.get('submodel');
    if (submodelJson != null) {
      return Submodel.fromJson(Map<String, dynamic>.from(submodelJson));
    }
    return null;
  }

  /// Store individual nameplate property
  static Future<void> storeNameplateProperty(String key, dynamic value) async {
    await nameplateBox.put(key, value);
  }

  /// Get individual nameplate property
  static T? getNameplateProperty<T>(String key) {
    return nameplateBox.get(key) as T?;
  }

  /// Clear all nameplate data
  static Future<void> clearNameplateData() async {
    await nameplateBox.clear();
  }

  /// Check if nameplate data exists
  static bool hasNameplateData() {
    return nameplateBox.containsKey('submodel');
  }

  /// Get all keys in nameplate box
  static Iterable<dynamic> getNameplateKeys() {
    return nameplateBox.keys;
  }

  /// Close all boxes (call on app disposal)
  static Future<void> close() async {
    await _nameplateBox?.close();
  }
}