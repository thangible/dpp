import 'package:flutter/material.dart';

/// Semantic colors the default [ColorScheme] doesn't model (success/warning/
/// info roles, plus the small categorical palette used for pie/bar charts),
/// registered on both [AppTheme.light] and [AppTheme.dark] so call sites can
/// do `Theme.of(context).extension<AppSemanticColors>()!.success` instead of
/// reaching for raw `Colors.green` / `Colors.orange` that don't adapt to
/// dark mode.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color warning;
  final Color info;
  final List<Color> chartPalette;

  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.chartPalette,
  });

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    List<Color>? chartPalette,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      chartPalette: chartPalette ?? this.chartPalette,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      chartPalette: [
        for (var i = 0; i < chartPalette.length; i++)
          Color.lerp(chartPalette[i], other.chartPalette[i], t)!,
      ],
    );
  }
}

/// Convenience accessor: `context.semanticColors.success`.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
