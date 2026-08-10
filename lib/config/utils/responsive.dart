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
