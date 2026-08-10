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
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      label: 'Products',
      index: 0,
      isSelected: true,
    ),
    TabIconData(
      icon: Icons.precision_manufacturing_outlined,
      selectedIcon: Icons.precision_manufacturing,
      label: 'Process',
      index: 1,
      isSelected: false,
    ),
    TabIconData(
      icon: Icons.history,
      selectedIcon: Icons.history,
      label: 'History',
      index: 2,
      isSelected: false,
    ),
    TabIconData(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
      index: 3,
      isSelected: false,
    ),
  ];
}
