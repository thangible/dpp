import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/navigation/models/drawer_model.dart';



class DrawerUserController extends GetxController with GetTickerProviderStateMixin {
  final double drawerWidth;
  final Function(DrawerIndex)? onDrawerCall;
  final Function(bool)? drawerIsOpen;

  late ScrollController scrollController;
  late AnimationController iconAnimationController;
  late AnimationController animationController;

  // reactive state for scroll offset
  RxDouble scrollOffset = 0.0.obs;

  DrawerUserController({
    this.drawerWidth = 250,
    this.onDrawerCall,
    this.drawerIsOpen,
  });

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    iconAnimationController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 0),
      curve: Curves.fastOutSlowIn,
    );

    scrollController = ScrollController(
      initialScrollOffset: drawerWidth,
    );
    scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => getInitState());
  }

  void _onScroll() {
    double offset = scrollController.offset;
    if (offset <= 0) {
      if (scrollOffset.value != 1.0) {
        scrollOffset.value = 1.0;
        drawerIsOpen?.call(true);
      }
      iconAnimationController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 0),
        curve: Curves.fastOutSlowIn,
      );
    } else if (offset > 0 && offset < drawerWidth.floor()) {
      double progress = (offset * 100 / (drawerWidth)) / 100;
      iconAnimationController.animateTo(
        progress,
        duration: const Duration(milliseconds: 0),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      if (scrollOffset.value != 0.0) {
        scrollOffset.value = 0.0;
        drawerIsOpen?.call(false);
      }
      iconAnimationController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 0),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<bool> getInitState() async {
    scrollController.jumpTo(drawerWidth);
    return true;
  }

  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    iconAnimationController.dispose();
    animationController.dispose();
    super.onClose();
  }
}