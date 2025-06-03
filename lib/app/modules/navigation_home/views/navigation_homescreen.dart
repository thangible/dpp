import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
// Controllers
import 'package:dpp/app/modules/navigation_home/controllers/drawer_user_controller.dart';
// DRAWER
import 'package:dpp/app/modules/home/views/widgets/home_drawer.dart';

import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation_home/controllers/navigation_home_controller.dart';


class NavigationHomeScreen extends GetView<NavigationHomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: Obx(() {
            // Check API state and show appropriate UI.
            if (controller.apiStatus.value == ApiCallStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.apiStatus.value == ApiCallStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Error fetching data.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.fetchData(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else {
              // API success: Render the drawer and screen view.
              return DrawerUserController(
                screenIndex: controller.drawerIndex.value,
                drawerWidth: MediaQuery.of(context).size.width * 0.75,
                onDrawerCall: (DrawerIndex drawerIndexData) {
                  controller.changeIndex(drawerIndexData);
                },
                screenView: controller.screenView.value,
              );
            }
          }),
        ),
      ),
    );
  }
}