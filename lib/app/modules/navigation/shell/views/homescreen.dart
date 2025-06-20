import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:get/get.dart';
// Controllers
import 'package:dpp/app/modules/navigation/shell/controllers/drawer_controller.dart';
import 'package:dpp/app/modules/navigation/shell/controllers/navigation_controller.dart';
// DRAWER
import 'package:dpp/app/modules/navigation/shell/views/widgets/app_navigation_drawer.dart';
// Models
import 'package:dpp/app/modules/navigation/models/drawer_model.dart';


class HomeScreen extends GetView<NavigationController> {
  @override
  Widget build(BuildContext context) {
    // Ensure DrawerUserController is injected.
    Get.put<DrawerUserController>(
      DrawerUserController(
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: (DrawerIndex drawerIndexData) {
          controller.changeIndex(drawerIndexData);
        },
      ),
    );

    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false, 
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: Obx(() {
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
    Key? key,
    this.screenView,
    this.menuView,
    this.screenIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawerUserController>();

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
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
                        iconAnimationController: controller.iconAnimationController,
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
                    color: AppTheme.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.grey.withOpacity(0.6),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Obx(() => IgnorePointer(
                        ignoring: controller.scrollOffset.value == 1.0,
                        child: screenView,
                      )),
                      Obx(() => controller.scrollOffset.value == 1.0
                          ? InkWell(
                              onTap: () {
                                controller.onDrawerClick();
                              },
                            )
                          : Container()),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 8,
                        ),
                        child: SizedBox(
                          width: AppBar().preferredSize.height - 8,
                          height: AppBar().preferredSize.height - 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppBar().preferredSize.height,
                              ),
                              child: Center(
                                child: menuView ??
                                    AnimatedIcon(
                                      color: isLightMode
                                          ? AppTheme.dark_grey
                                          : AppTheme.white,
                                      icon: AnimatedIcons.arrow_menu,
                                      progress: controller.iconAnimationController,
                                    ),
                              ),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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