import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Controllers
import 'package:dpp/legacy/navigation_controller.dart';
import 'package:dpp/legacy/drawer_user_controller.dart';
// DRAWER
import 'package:dpp/legacy/app_navigation_drawer.dart';
// Models
import 'package:dpp/legacy/drawer_model.dart';
import 'package:dpp/config/utils/responsive.dart';

class HomeScreen extends GetView<NavigationController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surface,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Obx(() {
            if (controller.apiStatus.value == ApiCallStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.apiStatus.value == ApiCallStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error fetching data.",
                      style: Theme.of(context).textTheme.bodyLarge,
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
              return AppNavigationScaffold(
                screenView: controller.screenView.value,
                screenIndex: controller.drawerIndex.value,
              );
            }
          }),
        ),
      ),
    );
  }
}

class AppNavigationScaffold extends StatelessWidget {
  final Widget? screenView;
  final Widget? menuView;
  final DrawerIndex? screenIndex;

  const AppNavigationScaffold({
    super.key,
    this.screenView,
    this.menuView,
    this.screenIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawerUserController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width + controller.drawerWidth,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: controller.drawerWidth,
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: controller.iconAnimationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform(
                      transform: Matrix4.translationValues(
                        controller.scrollController.offset,
                        0.0,
                        0.0,
                      ),
                      child: AppNavigationDrawer(
                        screenIndex: screenIndex ?? DrawerIndex.HOME,
                        iconAnimationController:
                            controller.iconAnimationController,
                        callBackIndex: (DrawerIndex indexType) {
                          controller.onDrawerClick();
                          controller.onDrawerCall?.call(indexType);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.3),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Obx(
                        () => IgnorePointer(
                          ignoring: controller.scrollOffset.value == 1.0,
                          child: screenView,
                        ),
                      ),
                      Obx(
                        () =>
                            controller.scrollOffset.value == 1.0
                                ? InkWell(
                                  onTap: () {
                                    controller.onDrawerClick();
                                  },
                                )
                                : Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 8,
                        ),
                        child: SizedBox(
                          // Same height every top-level screen's header
                          // reserves for its own content (AppBreakpoints.
                          // topBarZoneHeight) and vertically centers within
                          // — that's what keeps this hamburger and e.g. the
                          // Home mode pills sharing one vertical center
                          // instead of two independently-guessed paddings.
                          width: AppBreakpoints.topBarZoneHeight,
                          height: AppBreakpoints.topBarZoneHeight,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppBreakpoints.topBarZoneHeight,
                              ),
                              child: Center(
                                child:
                                    menuView ??
                                    AnimatedIcon(
                                      color: colors.onSurface,
                                      icon: AnimatedIcons.arrow_menu,
                                      progress:
                                          controller.iconAnimationController,
                                    ),
                              ),
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());
                                controller.onDrawerClick();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
