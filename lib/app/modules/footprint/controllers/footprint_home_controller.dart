import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/config/utils/tabIcon_data.dart';
import 'package:dpp/app/modules/home/views/home_view.dart';
import 'package:dpp/app/modules/footprint/views/history/history_favorites_view.dart';
import 'package:dpp/app/modules/footprint/views/profile/profile_view.dart';
import 'package:dpp/app/modules/footprint/views/more/more_view.dart';

class AppHomeController extends GetxController {
  Rx<Widget> tabBody = Rx<Widget>(const SizedBox.shrink());
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  void onInit() {
    // initialize tab icons
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    tabBody.value = const HomeView();
    super.onInit();
  }

  void changePage(int index) {
    switch (index) {
      case 0:
        tabBody.value = const HomeView();
      case 1:
        tabBody.value = const HistoryFavoritesScreen();
      case 2:
        tabBody.value = const ProfileScreen();
      case 3:
        tabBody.value = const MoreScreen();
    }
  }
}
