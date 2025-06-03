// filepath: lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation_home/views/navigation_homescreen.dart';
import 'package:dpp/app/modules/navigation_home/bindings/nevigation_home_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.NAVIGATION_HOME;
  
  static final pages = [
    GetPage(
      name: Routes.NAVIGATION_HOME,
      page: () => NavigationHomeScreen(),
      binding: NavigationHomeBinding(),
    ),
    // Future pages can be added here in a similar way
  ];
}