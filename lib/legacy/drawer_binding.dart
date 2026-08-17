import 'package:get/get.dart';
import 'package:dpp/legacy/drawer_user_controller.dart';

class DrawerUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawerUserController>(
      () => DrawerUserController(drawerWidth: 250),
    );
  }
}
