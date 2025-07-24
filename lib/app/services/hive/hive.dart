import 'package:hive/hive.dart';
import 'package:dpp/app/data/hive_models.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local storage service using Hive database
class HiveService {
  static const String _nameplatesBox = 'nameplates';
  static const String _productsBox = 'products';
  static const String _manufacturersBox = 'manufacturers';
  static const String _markingsBox = 'markings';
  static const String _settingsBox = 'settings';

  static Box<Nameplate>? _nameplatesBoxRef;
  static Box<Product>? _productsBoxRef;
  static Box<Manufacturer>? _manufacturersBoxRef;
  static Box<Markings>? _markingsBoxRef;
  static Box? _settingsBoxRef;

  /// Initialize Hive with adapters and boxes
  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register type adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(NameplateAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ProductAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ManufacturerAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(MarkingsAdapter());
      }

      // Open all boxes
      _nameplatesBoxRef = await Hive.openBox<Nameplate>(_nameplatesBox);
      _productsBoxRef = await Hive.openBox<Product>(_productsBox);
      _manufacturersBoxRef = await Hive.openBox<Manufacturer>(
        _manufacturersBox,
      );
      _markingsBoxRef = await Hive.openBox<Markings>(_markingsBox);
      _settingsBoxRef = await Hive.openBox(_settingsBox);

      debugPrint('✅ Hive initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Hive: $e');
      rethrow;
    }
  }

  // Box getters with initialization checks
  static Box<Nameplate> get nameplatesBox {
    if (_nameplatesBoxRef == null) {
      throw Exception(
        'Nameplates box not initialized. Call HiveService.init() first.',
      );
    }
    return _nameplatesBoxRef!;
  }

  static Box<Product> get productsBox {
    if (_productsBoxRef == null) {
      throw Exception(
        'Products box not initialized. Call HiveService.init() first.',
      );
    }
    return _productsBoxRef!;
  }

  static Box<Manufacturer> get manufacturersBox {
    if (_manufacturersBoxRef == null) {
      throw Exception(
        'Manufacturers box not initialized. Call HiveService.init() first.',
      );
    }
    return _manufacturersBoxRef!;
  }

  static Box<Markings> get markingsBox {
    if (_markingsBoxRef == null) {
      throw Exception(
        'Markings box not initialized. Call HiveService.init() first.',
      );
    }
    return _markingsBoxRef!;
  }

  static Box get settingsBox {
    if (_settingsBoxRef == null) {
      throw Exception(
        'Settings box not initialized. Call HiveService.init() first.',
      );
    }
    return _settingsBoxRef!;
  }

  // Nameplate operations
  static Future<String> saveNameplate(Nameplate nameplate) async {
    try {
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      await nameplatesBox.put(key, nameplate);
      debugPrint('✅ Saved nameplate: $key');
      return key;
    } catch (e) {
      debugPrint('❌ Error saving nameplate: $e');
      rethrow;
    }
  }

  static Nameplate? getNameplate(String key) {
    try {
      return nameplatesBox.get(key);
    } catch (e) {
      debugPrint('❌ Error getting nameplate: $e');
      return null;
    }
  }

  static List<Nameplate> getAllNameplates() {
    try {
      return nameplatesBox.values.toList();
    } catch (e) {
      debugPrint('❌ Error getting all nameplates: $e');
      return [];
    }
  }

  static Future<void> deleteNameplate(String key) async {
    try {
      await nameplatesBox.delete(key);
      debugPrint('✅ Deleted nameplate: $key');
    } catch (e) {
      debugPrint('❌ Error deleting nameplate: $e');
    }
  }

  // Product operations
  static Future<String> saveProduct(Product product) async {
    try {
      final key =
          product.serialNumber ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await productsBox.put(key, product);
      debugPrint('✅ Saved product: $key');
      return key;
    } catch (e) {
      debugPrint('❌ Error saving product: $e');
      rethrow;
    }
  }

  static Product? getProduct(String key) {
    try {
      return productsBox.get(key);
    } catch (e) {
      debugPrint('❌ Error getting product: $e');
      return null;
    }
  }

  static List<Product> getAllProducts() {
    try {
      return productsBox.values.toList();
    } catch (e) {
      debugPrint('❌ Error getting all products: $e');
      return [];
    }
  }

  static List<Product> searchProducts(String query) {
    try {
      final queryLower = query.toLowerCase();
      return productsBox.values.where((product) {
        return (product.serialNumber?.toLowerCase().contains(queryLower) ??
                false) ||
            (product.manufacturerProductType?.toLowerCase().contains(
                  queryLower,
                ) ??
                false) ||
            (product.manufacturerProductDesignation?.toLowerCase().contains(
                  queryLower,
                ) ??
                false) ||
            (product.orderCodeOfManufacturer?.toLowerCase().contains(
                  queryLower,
                ) ??
                false);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error searching products: $e');
      return [];
    }
  }

  // Manufacturer operations
  static Future<String> saveManufacturer(Manufacturer manufacturer) async {
    try {
      final key =
          manufacturer.uniqueFacilityIdentifier ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await manufacturersBox.put(key, manufacturer);
      debugPrint('✅ Saved manufacturer: $key');
      return key;
    } catch (e) {
      debugPrint('❌ Error saving manufacturer: $e');
      rethrow;
    }
  }

  static Manufacturer? getManufacturer(String key) {
    try {
      return manufacturersBox.get(key);
    } catch (e) {
      debugPrint('❌ Error getting manufacturer: $e');
      return null;
    }
  }

  static List<Manufacturer> getAllManufacturers() {
    try {
      return manufacturersBox.values.toList();
    } catch (e) {
      debugPrint('❌ Error getting all manufacturers: $e');
      return [];
    }
  }

  // Markings operations
  static Future<String> saveMarkings(Markings markings) async {
    try {
      final key =
          markings.markingName ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await markingsBox.put(key, markings);
      debugPrint('✅ Saved markings: $key');
      return key;
    } catch (e) {
      debugPrint('❌ Error saving markings: $e');
      rethrow;
    }
  }

  static Markings? getMarkings(String key) {
    try {
      return markingsBox.get(key);
    } catch (e) {
      debugPrint('❌ Error getting markings: $e');
      return null;
    }
  }

  static List<Markings> getAllMarkings() {
    try {
      return markingsBox.values.toList();
    } catch (e) {
      debugPrint('❌ Error getting all markings: $e');
      return [];
    }
  }

  // Settings operations
  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
      debugPrint('✅ Saved setting: $key');
    } catch (e) {
      debugPrint('❌ Error saving setting: $e');
    }
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      final value = settingsBox.get(key, defaultValue: defaultValue);
      return value as T?;
    } catch (e) {
      debugPrint('❌ Error getting setting: $e');
      return defaultValue;
    }
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    try {
      return {
        'nameplates_count': nameplatesBox.length,
        'products_count': productsBox.length,
        'manufacturers_count': manufacturersBox.length,
        'markings_count': markingsBox.length,
        'cache_size_mb': _estimateCacheSize(),
      };
    } catch (e) {
      debugPrint('❌ Error getting cache stats: $e');
      return {};
    }
  }

  /// Estimate cache size in MB
  static double _estimateCacheSize() {
    final nameplatesSize = nameplatesBox.length * 0.5; // ~500 bytes
    final productsSize = productsBox.length * 0.8; // ~800 bytes
    final manufacturersSize = manufacturersBox.length * 0.2; // ~200 bytes
    final markingsSize = markingsBox.length * 0.3; // ~300 bytes
    return nameplatesSize + productsSize + manufacturersSize + markingsSize;
  }

  /// Clear all stored data
  static Future<void> clearAllData() async {
    try {
      await nameplatesBox.clear();
      await productsBox.clear();
      await manufacturersBox.clear();
      await markingsBox.clear();
      await settingsBox.clear();
      debugPrint('✅ Cleared all Hive data');
    } catch (e) {
      debugPrint('❌ Error clearing all data: $e');
    }
  }

  /// Close all Hive boxes
  static Future<void> dispose() async {
    try {
      await Hive.close();
      debugPrint('✅ Closed all Hive boxes');
    } catch (e) {
      debugPrint('❌ Error closing Hive boxes: $e');
    }
  }
}
