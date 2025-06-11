import 'package:get/get.dart';
import 'package:dpp/app/modules/home/controllers/app_home_controller.dart';

class AppHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppHomeController>(() => AppHomeController());
  }
}