// filepath: lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/footprint/views/footprint_home_view.dart';
import 'package:dpp/app/modules/auth/views/sign_in_screen.dart';
import 'package:dpp/app/modules/onboarding/views/onboarding_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.NAVIGATION_HOME;

  static final pages = [
    GetPage(
      name: Routes.NAVIGATION_HOME,
      page: () => const AppHomeScreen(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
    ),
    // Future pages can be added here in a similar way
  ];
} 