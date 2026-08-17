import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import 'package:dpp/app/services/hive/hive_service.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/app/modules/settings/controllers/theme_controller.dart';
import 'package:dpp/app/modules/settings/controllers/locale_controller.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/config/utils/responsive.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductService.init();
  await MaterialService.init();
  // Initialize Hive
  await HiveService.init();

  // Initialize services
  final themeController = Get.put(ThemeController(), permanent: true);
  final authController = Get.put(AuthController(), permanent: true);
  final localeController = Get.put(LocaleController(), permanent: true);
  Get.put(HistoryController(), permanent: true);

  // debugPaintSizeEnabled = true;

  // Lock phones to portrait (the layout is designed for it), but leave
  // tablets alone: ios/Runner/Info.plist already declares full rotation
  // support for iPad, and locking it here would silently override that.
  final isTablet = AppBreakpoints.isTabletView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  );
  if (!isTablet) {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  runApp(
    MyApp(
      themeController: themeController,
      authController: authController,
      localeController: localeController,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  final AuthController authController;
  final LocaleController localeController;

  const MyApp({
    super.key,
    required this.themeController,
    required this.authController,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DPP Mockup App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode.value,
      locale: localeController.locale.value,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute:
          !HiveService.hasSeenOnboarding()
              ? Routes.ONBOARDING
              : authController.isAuthenticated.value
              ? Routes.NAVIGATION_HOME
              : Routes.SIGN_IN,
      getPages: AppPages.pages,
      builder: (context, child) {
        // Keep the status/nav bar icon brightness in sync with whichever
        // theme is active (light/dark/system), instead of hardcoding it.
        final isDark = Theme.of(context).brightness == Brightness.dark;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness:
                !kIsWeb && Platform.isAndroid
                    ? (isDark ? Brightness.light : Brightness.dark)
                    : (isDark ? Brightness.dark : Brightness.light),
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
        );
        return child ?? const SizedBox();
      },
    );
  }
}
