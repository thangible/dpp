import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Adaptive-layout breakpoints. The app was designed phone-first (fixed
/// drawer/tab-bar widths); these helpers let a handful of call sites stay
/// sane on an iPad instead of stretching phone-sized chrome edge-to-edge.
class AppBreakpoints {
  AppBreakpoints._();

  /// Below this logical-pixel shortest side, treat the device as a phone.
  /// Matches the convention Flutter/Material itself uses for tablet
  /// detection.
  static const double tabletShortestSide = 600;

  /// Max width the bottom tab bar grows to before it's centered instead of
  /// stretched full-bleed.
  static const double tabBarMaxWidth = 480;

  /// Standard iOS/iPadOS sidebar width, used to cap the nav drawer.
  static const double drawerMaxWidth = 320;

  /// Height of the shared top zone every top-level screen's header content
  /// (mode pills, screen title, ...) reserves and vertically centers within
  /// — matches the drawer's own hamburger-button hit box (same value,
  /// [AppBar().preferredSize.height]) so the hamburger and whatever sits
  /// next to it always share one vertical center instead of two
  /// independently-guessed paddings that happen to be close.
  static const double topBarZoneHeight = 56;

  /// Left padding for that same header content: hamburger's own left
  /// inset (8) + its width (topBarZoneHeight) + a clean 8px gap.
  static const double topBarContentLeft = 8 + topBarZoneHeight + 8;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= tabletShortestSide;
  }

  /// Same shortest-side rule as [isTablet], usable before a [BuildContext]
  /// exists (e.g. in `main()` prior to `runApp`).
  static bool isTabletView(FlutterView view) {
    final shortestSide = view.physicalSize.shortestSide / view.devicePixelRatio;
    return shortestSide >= tabletShortestSide;
  }
}
