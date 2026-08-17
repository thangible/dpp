import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/footprint/bindings/footprint_home_binding.dart';
import 'package:dpp/app/modules/footprint/controllers/footprint_home_controller.dart';
import 'package:dpp/app/modules/footprint/views/bottom_bar_view.dart';
import 'package:dpp/app/modules/scanner/views/scanner_screen.dart';
import 'package:dpp/config/utils/motion.dart';

class AppHomeScreen extends StatelessWidget {
  const AppHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure dependencies are loaded
    AppHomeBinding().dependencies();
    final controller = Get.find<AppHomeController>();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: Future.delayed(const Duration(milliseconds: 200), () => true),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  Obx(
                    () => AnimatedSwitcher(
                      duration: AppMotion.normal,
                      switchInCurve: AppMotion.enter,
                      switchOutCurve: AppMotion.exit,
                      transitionBuilder:
                          (child, animation) => FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                      child: KeyedSubtree(
                        key: ValueKey(controller.tabBody.value.runtimeType),
                        child: controller.tabBody.value,
                      ),
                    ),
                  ),
                  _bottomBar(controller),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _bottomBar(AppHomeController controller) {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        BottomBarView(
          tabIconsList: controller.tabIconsList,
          addClick: () => Get.to(() => const ScannerScreen()),
          changeIndex: (int index) {
            controller.changePage(index);
          },
        ),
      ],
    );
  }
}