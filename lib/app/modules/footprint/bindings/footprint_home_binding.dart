import 'package:get/get.dart';
import 'package:dpp/app/modules/footprint/controllers/footprint_home_controller.dart';

class AppHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppHomeController>(() => AppHomeController());
  }
}