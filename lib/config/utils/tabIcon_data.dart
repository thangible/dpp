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
      // precision_manufacturing's glyph is drawn off-center (weighted to
      // the left within its bounding box), which reads as misaligned
      // against the centered label under it. factory is visually
      // symmetric and still reads as "manufacturing process".
      icon: Icons.factory_outlined,
      selectedIcon: Icons.factory,
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
