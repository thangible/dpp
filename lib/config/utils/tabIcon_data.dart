import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.icon = Icons.circle_outlined,
    this.selectedIcon = Icons.circle,
    this.label = '',
    this.index = 0,
    this.isSelected = false,
    this.animationController,
  });

  IconData icon;
  IconData selectedIcon;
  String label;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      index: 0,
      isSelected: true,
    ),
    TabIconData(
      icon: Icons.history,
      selectedIcon: Icons.history,
      label: 'History',
      index: 1,
      isSelected: false,
    ),
    TabIconData(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
      index: 2,
      isSelected: false,
    ),
    TabIconData(
      icon: Icons.more_horiz_outlined,
      selectedIcon: Icons.more_horiz,
      label: 'More',
      index: 3,
      isSelected: false,
    ),
  ];
}
