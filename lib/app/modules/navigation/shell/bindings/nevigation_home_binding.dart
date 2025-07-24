// filepath: lib/app/modules/navigation_home/bindings/navigation_home_binding.dart
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation/shell/controllers/navigation_controller.dart';
import 'package:dpp/app/modules/navigation/shell/controllers/drawer_user_controller.dart';
import 'package:dpp/app/modules/navigation/models/drawer_model.dart';

class NavigationHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());

    // Bind DrawerUserController
    Get.lazyPut<DrawerUserController>(
      () => DrawerUserController(
        drawerWidth: Get.width * 0.75, // Using Get.width instead of MediaQuery
        onDrawerCall: (DrawerIndex drawerIndexData) {
          Get.find<NavigationController>().changeIndex(drawerIndexData);
        },
      ),
    );
  }
}
