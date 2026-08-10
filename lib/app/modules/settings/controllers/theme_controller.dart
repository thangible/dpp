import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/services/hive/hive_service.dart';

/// Drives light/dark mode app-wide via `Get.changeThemeMode`, persisting the
/// choice in Hive so it survives restarts. Register with `Get.put` before
/// `runApp` so its initial value matches what was passed into
/// `GetMaterialApp(themeMode: ...)`.
class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = HiveService.getThemeMode().obs;

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode.value == ThemeMode.dark;
  }

  void toggleDarkMode(bool enabled) {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    HiveService.saveThemeMode(mode);
  }
}
