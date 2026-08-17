import 'package:flutter/animation.dart';

/// Centralized animation timing so every transition in the app feels like
/// part of the same system: smooth ease curves everywhere, no bounce/
/// overshoot, no linear "robotic" motion. Pick the curve that matches the
/// shape of the motion (symmetric interactions vs. one-shot reveals) rather
/// than using a single curve for everything regardless of context.
class AppMotion {
  AppMotion._();

  /// Default for anything reversible / driven back and forth (drawer
  /// swipe, toggles, tab selection).
  static const Curve curve = Curves.easeInOutCubic;

  /// One-shot entrances (something appearing, sliding/fading in).
  static const Curve enter = Curves.easeOutCubic;

  /// One-shot exits (something leaving/fading out).
  static const Curve exit = Curves.easeInCubic;

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 420);
}
