import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/services/hive/hive_service.dart';

/// Drives the app's language (English/German), persisting the choice in
/// Hive. Null means "follow the device locale" — GetMaterialApp's
/// `supportedLocales` still constrains it to en/de either way.
class LocaleController extends GetxController {
  final Rx<Locale?> locale = Rx<Locale?>(null);

  @override
  void onInit() {
    super.onInit();
    final code = HiveService.getLocaleCode();
    if (code != null) {
      locale.value = Locale(code);
    }
  }

  void setLocale(Locale? newLocale) {
    locale.value = newLocale;
    HiveService.saveLocaleCode(newLocale?.languageCode);
    if (newLocale != null) {
      Get.updateLocale(newLocale);
    } else {
      // "Match system": fall back to the device locale GetX already read
      // at startup.
      Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
    }
  }
}
