import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/legacy/drawer_model.dart';
import 'package:dpp/app/modules/settings/controllers/theme_controller.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/config/utils/motion.dart';

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({
    super.key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
  });

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _AppNavigationDrawerState createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  List<DrawerList> _drawerListFor(AppLocalizations l10n) {
    return <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: l10n.tabHome,
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: l10n.drawerHelp,
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: l10n.drawerFeedback,
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: l10n.drawerInviteFriend,
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: l10n.drawerRateApp,
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: l10n.drawerAboutUs,
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final drawerList = _drawerListFor(l10n);
    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                          1.0 - (widget.iconAnimationController!.value) * 0.2,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(
                            Tween<double>(begin: 0.0, end: 24.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: widget.iconAnimationController!,
                                        curve: AppMotion.curve,
                                      ),
                                    )
                                    .value /
                                360,
                          ),
                          child: Container(
                            height: 92,
                            width: 92,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.25),
                                width: 2,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: colors.shadow.withValues(alpha: 0.25),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(46.0),
                              ),
                              child: Image.asset('assets/images/userImage.jpg'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 4),
                    child: Obx(
                      () => Text(
                        Get.find<AuthController>().displayName.value,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4),
                    child: Text(
                      l10n.appSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Divider(height: 1, color: colors.outlineVariant),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index], colors, theme);
              },
            ),
          ),
          Divider(height: 1, color: colors.outlineVariant),
          _DarkModeToggle(colors: colors, theme: theme),
          Divider(height: 1, color: colors.outlineVariant),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  l10n.drawerSignOut,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(Icons.power_settings_new, color: colors.error),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onTapped() async {
    await Get.find<AuthController>().signOut();
    Get.offAllNamed(Routes.SIGN_IN);
  }

  Widget inkwell(DrawerList listData, ColorScheme colors, ThemeData theme) {
    final bool isSelected = widget.screenIndex == listData.index;
    final Color itemColor = isSelected ? colors.primary : colors.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: colors.primary.withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            if (isSelected)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20.0,
              ),
              child: Row(
                children: <Widget>[
                  listData.isAssetsImage
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset(
                          listData.imageName,
                          color: itemColor,
                        ),
                      )
                      : Icon(listData.icon?.icon, color: itemColor, size: 24),
                  const SizedBox(width: 20),
                  Text(
                    listData.labelName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: itemColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

/// Dark mode switch shown in the drawer footer, wired to [ThemeController].
class _DarkModeToggle extends StatelessWidget {
  final ColorScheme colors;
  final ThemeData theme;

  const _DarkModeToggle({required this.colors, required this.theme});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    return Obx(
      () => SwitchListTile(
        value: controller.isDarkMode,
        onChanged: controller.toggleDarkMode,
        secondary: Icon(
          controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: colors.onSurfaceVariant,
        ),
        title: Text(
          AppLocalizations.of(context)!.drawerDarkMode,
          style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
        ),
      ),
    );
  }
}
