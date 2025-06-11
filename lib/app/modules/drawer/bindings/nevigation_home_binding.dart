// filepath: lib/app/modules/navigation_home/bindings/navigation_home_binding.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation/controllers/navigation_home_controller.dart';

class NavigationHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationHomeController>(() => NavigationHomeController());
  }
}