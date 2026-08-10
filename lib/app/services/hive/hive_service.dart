import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';

class HiveService {
  static const String _nameplateBoxName = 'nameplate';
  static const String _settingsBoxName = 'settings';
  static const String _historyBoxName = 'history';
  static const String _themeModeKey = 'themeMode';
  static const String _sessionKey = 'session';
  static const String _historyEntriesKey = 'entries';
  static Box? _nameplateBox;
  static Box? _settingsBox;
  static Box? _historyBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _nameplateBox = await Hive.openBox(_nameplateBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _historyBox = await Hive.openBox(_historyBoxName);
  }

  /// Get the nameplate box
  static Box get nameplateBox {
    if (_nameplateBox == null) {
      throw Exception('HiveService not initialized. Call HiveService.init() first.');
    }
    return _nameplateBox!;
  }

  /// Get the settings box
  static Box get settingsBox {
    if (_settingsBox == null) {
      throw Exception('HiveService not initialized. Call HiveService.init() first.');
    }
    return _settingsBox!;
  }

  /// Get the history/favorites box
  static Box get historyBox {
    if (_historyBox == null) {
      throw Exception('HiveService not initialized. Call HiveService.init() first.');
    }
    return _historyBox!;
  }

  // --- Auth session ---
  // Only ever written for a real signed-in user; guest sessions are kept
  // in-memory by AuthController and never reach here, so a guest is always
  // back at sign-in on next launch.

  /// Read the persisted session, if any (`{username, displayName}`).
  static Map<String, dynamic>? getSession() {
    final stored = settingsBox.get(_sessionKey);
    if (stored == null) return null;
    return Map<String, dynamic>.from(stored as Map);
  }

  static Future<void> saveSession({
    required String username,
    required String displayName,
  }) async {
    await settingsBox.put(_sessionKey, {
      'username': username,
      'displayName': displayName,
    });
  }

  static Future<void> clearSession() async {
    await settingsBox.delete(_sessionKey);
  }

  // --- History / favorites ---

  /// Raw stored entries, newest first. See `HistoryEntry.toJson`/`fromJson`
  /// for the shape.
  static List<Map<String, dynamic>> getHistoryEntries() {
    final stored = historyBox.get(_historyEntriesKey) as List?;
    if (stored == null) return [];
    return stored.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> saveHistoryEntries(
    List<Map<String, dynamic>> entries,
  ) async {
    await historyBox.put(_historyEntriesKey, entries);
  }

  // --- Theme preference ---

  /// Read the persisted theme mode, defaulting to following the system.
  static ThemeMode getThemeMode() {
    final stored = settingsBox.get(_themeModeKey) as String?;
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Persist the user's chosen theme mode.
  static Future<void> saveThemeMode(ThemeMode mode) async {
    await settingsBox.put(_themeModeKey, mode.name);
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