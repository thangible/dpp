import 'package:flutter/material.dart';
import 'package:dpp/config/utils/tabIcon_data.dart';
import 'package:dpp/config/utils/responsive.dart';
import 'package:dpp/config/utils/motion.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

/// TabIconData.label is a plain English fallback (used before context/l10n
/// is available); the bar itself always displays the localized version,
/// looked up by tab index so it stays correct if the language changes.
String _tabLabel(int index, AppLocalizations l10n) {
  switch (index) {
    case 0:
      return l10n.tabHome;
    case 1:
      return l10n.tabHistory;
    case 2:
      return l10n.tabProfile;
    case 3:
      return l10n.tabMore;
    default:
      return '';
  }
}

/// Bottom navigation: Home / History / Profile / More plus the scan action,
/// laid out as five EQUAL-width slots (Home | History | Scan | Profile |
/// More) — two real tabs on each side of the FAB, genuinely symmetric,
/// rather than stretching one tab to fake a centered gap around an odd
/// number of tabs.
class BottomBarView extends StatefulWidget {
  const BottomBarView({
    super.key,
    this.tabIconsList,
    this.changeIndex,
    this.addClick,
  });

  final Function(int index)? changeIndex;
  final Function()? addClick;
  final List<TabIconData>? tabIconsList;

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  void _select(int index) {
    setState(() {
      for (final tab in widget.tabIconsList ?? <TabIconData>[]) {
        tab.isSelected = tab.index == index;
      }
    });
    widget.changeIndex?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoints.tabBarMaxWidth,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.14),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: 68,
            child: Row(
              // stretch, not center: without it each tab's InkWell only
              // gets its own intrinsic (icon+label) height, leaving a dead
              // strip above/below every tab where taps don't register.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _NavTab(
                    icon: widget.tabIconsList?[0].icon ?? Icons.home_outlined,
                    selectedIcon:
                        widget.tabIconsList?[0].selectedIcon ?? Icons.home,
                    label: _tabLabel(0, l10n),
                    isSelected: widget.tabIconsList?[0].isSelected ?? false,
                    onTap: () => _select(0),
                  ),
                ),
                Expanded(
                  child: _NavTab(
                    icon: widget.tabIconsList?[1].icon ?? Icons.history,
                    selectedIcon:
                        widget.tabIconsList?[1].selectedIcon ?? Icons.history,
                    label: _tabLabel(1, l10n),
                    isSelected: widget.tabIconsList?[1].isSelected ?? false,
                    onTap: () => _select(1),
                  ),
                ),
                Expanded(child: _ScanSlot(onTap: widget.addClick)),
                Expanded(
                  child: _NavTab(
                    icon:
                        widget.tabIconsList?[2].icon ?? Icons.person_outline,
                    selectedIcon:
                        widget.tabIconsList?[2].selectedIcon ?? Icons.person,
                    label: _tabLabel(2, l10n),
                    isSelected: widget.tabIconsList?[2].isSelected ?? false,
                    onTap: () => _select(2),
                  ),
                ),
                Expanded(
                  child: _NavTab(
                    icon:
                        widget.tabIconsList?[3].icon ??
                        Icons.more_horiz_outlined,
                    selectedIcon:
                        widget.tabIconsList?[3].selectedIcon ??
                        Icons.more_horiz,
                    label: _tabLabel(3, l10n),
                    isSelected: widget.tabIconsList?[3].isSelected ?? false,
                    onTap: () => _select(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final color = isSelected ? colors.primary : colors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      splashColor: colors.primary.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: AppMotion.fast,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.exit,
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
            child: Icon(
              isSelected ? selectedIcon : icon,
              key: ValueKey<bool>(isSelected),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: AppMotion.normal,
            curve: AppMotion.curve,
            style:
                theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ) ??
                TextStyle(color: color),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

/// The scan action lives in its own slot (same width as every tab) but is
/// styled as a raised, filled circle that pops just above the bar's top
/// edge — visually distinct without needing the row itself to be uneven.
class _ScanSlot extends StatelessWidget {
  const _ScanSlot({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withValues(alpha: 0.15),
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.qr_code_scanner,
                color: colors.onPrimary,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
