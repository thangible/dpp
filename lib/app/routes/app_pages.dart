// filepath: lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation/shell/views/homescreen.dart';
import 'package:dpp/app/modules/navigation/shell/bindings/nevigation_home_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.NAVIGATION_HOME;
  
  static final pages = [
    GetPage(
      name: Routes.NAVIGATION_HOME,
      page: () => HomeScreen(),
      binding: NavigationHomeBinding(),
    ),
    // Future pages can be added here in a similar way
  ];
} 