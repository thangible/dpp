import 'package:get/get.dart';
import '../controllers/drawer_user_controller.dart';

class DrawerUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawerUserController>(
      () => DrawerUserController(drawerWidth: 250),
    );
  }
}
