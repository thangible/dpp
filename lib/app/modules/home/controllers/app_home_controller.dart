import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/config/utils/tabIcon_data.dart';
import 'package:dpp/app/modules/home/views/product_screen.dart';
import 'package:dpp/app/modules/home/views/process_screen.dart';

class AppHomeController extends GetxController implements TickerProvider {
  late AnimationController animationController;
  Rx<Widget> tabBody = Rx<Widget>(Container(color: AppTheme.background));
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  @override
  void onInit() {
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
    if (index == 0 || index == 2) {
      animationController.reverse().then((_) {
        tabBody.value = ProductScreen(animationController: animationController);
      });
    } else if (index == 1 || index == 3) {
      animationController.reverse().then((_) {
        tabBody.value = ProcessScreen(animationController: animationController);
      });
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}