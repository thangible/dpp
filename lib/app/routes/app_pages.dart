// filepath: lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation/shell/views/homescreen.dart';
import 'package:dpp/app/modules/navigation/shell/bindings/nevigation_home_binding.dart';
import 'package:dpp/app/modules/auth/views/sign_in_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.NAVIGATION_HOME;

  static final pages = [
    GetPage(
      name: Routes.NAVIGATION_HOME,
      page: () => HomeScreen(),
      binding: NavigationHomeBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
    ),
    // Future pages can be added here in a similar way
  ];
} 