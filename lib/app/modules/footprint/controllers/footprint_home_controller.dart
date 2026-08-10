import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:dpp/config/utils/tabIcon_data.dart';
import 'package:dpp/app/modules/footprint/views/product/product_view.dart';
import 'package:dpp/app/modules/footprint/views/process/process_view.dart';
import 'package:dpp/app/modules/footprint/views/history/history_favorites_view.dart';
import 'package:dpp/app/modules/footprint/views/profile/profile_view.dart';

class AppHomeController extends GetxController implements TickerProvider {
  late AnimationController animationController;
  Rx<Widget> tabBody = Rx<Widget>(const SizedBox.shrink());
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  @override
  void onInit() {
    // ProductService.init();
    // initialize tab icons
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    tabBody.value = ProductScreen(animationController: animationController);
    super.onInit();
  }

  void changePage(int index) {
    // Reset instantly (no visible reverse-out wait) so the switch itself
    // feels immediate; the outer AnimatedSwitcher in AppHomeScreen handles
    // the cross-fade, and this lets the new screen's own card stagger play
    // from the start via .forward().
    animationController.value = 0;
    switch (index) {
      case 0:
        tabBody.value = ProductScreen(animationController: animationController);
      case 1:
        tabBody.value = ProcessScreen(animationController: animationController);
      case 2:
        tabBody.value = const HistoryFavoritesScreen();
      case 3:
        tabBody.value = const ProfileScreen();
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
