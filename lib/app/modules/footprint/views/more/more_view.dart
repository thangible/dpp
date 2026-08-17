import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/modules/settings/controllers/theme_controller.dart';
import 'package:dpp/app/modules/navigation/drawer_links/help/help_screen.dart';
import 'package:dpp/app/modules/navigation/drawer_links/feedback/feedback_screen.dart';
import 'package:dpp/app/modules/navigation/drawer_links/invite_friend/invite_friend_screen.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'package:dpp/config/utils/motion.dart';

/// Everything that used to live in the slide-out drawer (help/feedback/
/// invite/rate/about, dark mode, sign out) now lives here as an ordinary
/// tab instead — no hamburger, no hidden panel, just another destination
/// next to Profile.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final auth = Get.find<AuthController>();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(l10n.tabMore, style: theme.textTheme.headlineSmall),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  Obx(
                    () => _UserCard(
                      colors: colors,
                      theme: theme,
                      name: auth.displayName.value,
                      subtitle: l10n.appSubtitle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _MoreTile(
                    icon: Icons.help_outline,
                    label: l10n.drawerHelp,
                    colors: colors,
                    theme: theme,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpScreen(),
                          ),
                        ),
                  ),
                  _MoreTile(
                    icon: Icons.chat_bubble_outline,
                    label: l10n.drawerFeedback,
                    colors: colors,
                    theme: theme,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FeedbackScreen(),
                          ),
                        ),
                  ),
                  _MoreTile(
                    icon: Icons.group_outlined,
                    label: l10n.drawerInviteFriend,
                    colors: colors,
                    theme: theme,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InviteFriend(),
                          ),
                        ),
                  ),
                  _MoreTile(
                    icon: Icons.star_outline,
                    label: l10n.drawerRateApp,
                    colors: colors,
                    theme: theme,
                    onTap: () => _comingSoon(context, l10n),
                  ),
                  _MoreTile(
                    icon: Icons.info_outline,
                    label: l10n.drawerAboutUs,
                    colors: colors,
                    theme: theme,
                    onTap: () => _comingSoon(context, l10n),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: colors.outlineVariant),
                  const SizedBox(height: 4),
                  _DarkModeTile(colors: colors, theme: theme, l10n: l10n),
                  const SizedBox(height: 4),
                  Divider(color: colors.outlineVariant),
                  const SizedBox(height: 4),
                  _MoreTile(
                    icon: Icons.power_settings_new,
                    label: l10n.drawerSignOut,
                    colors: colors,
                    theme: theme,
                    iconColor: colors.error,
                    labelColor: colors.error,
                    onTap: () async {
                      await auth.signOut();
                      Get.offAllNamed(Routes.SIGN_IN);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.commonComingSoon)));
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.colors,
    required this.theme,
    required this.name,
    required this.subtitle,
  });

  final ColorScheme colors;
  final ThemeData theme;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: colors.primary,
            child: Text(
              initial,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.label,
    required this.colors,
    required this.theme,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final ColorScheme colors;
  final ThemeData theme;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: colors.primary.withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? colors.onSurfaceVariant, size: 22),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: labelColor ?? colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (labelColor == null)
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkModeTile extends StatelessWidget {
  const _DarkModeTile({
    required this.colors,
    required this.theme,
    required this.l10n,
  });

  final ColorScheme colors;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Icon(
              controller.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: colors.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                l10n.drawerDarkMode,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: AppMotion.fast,
              switchInCurve: AppMotion.enter,
              switchOutCurve: AppMotion.exit,
              child: Switch(
                key: ValueKey<bool>(controller.isDarkMode),
                value: controller.isDarkMode,
                onChanged: controller.toggleDarkMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
