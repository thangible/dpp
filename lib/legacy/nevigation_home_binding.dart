// filepath: lib/app/modules/navigation_home/bindings/navigation_home_binding.dart
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:dpp/legacy/navigation_controller.dart';
import 'package:dpp/legacy/drawer_user_controller.dart';
import 'package:dpp/legacy/drawer_model.dart';
import 'package:dpp/config/utils/responsive.dart';

class NavigationHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());

    // Bind DrawerUserController
    Get.lazyPut<DrawerUserController>(
      () => DrawerUserController(
        // 75% of the screen on phone; capped to a standard sidebar width on
        // iPad so the drawer doesn't end up hundreds of points too wide.
        drawerWidth: math.min(
          Get.width * 0.75,
          AppBreakpoints.drawerMaxWidth,
        ),
        onDrawerCall: (DrawerIndex drawerIndexData) {
          Get.find<NavigationController>().changeIndex(drawerIndexData);
        },
      ),
    );
  }
}
