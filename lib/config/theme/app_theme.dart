import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_colors_extension.dart';

/// Central design system: brand colors, light/dark [ColorScheme]s, and the
/// full [ThemeData] (typography + component themes) every screen should
/// read from via `Theme.of(context)` rather than hardcoding colors.
class AppTheme {
  AppTheme._();

  // ---- Brand palette --------------------------------------------------
  // DHL-inspired: confident red + yellow on white/near-black, true-neutral
  // greys (no cool cast) so the accent colors carry the identity.
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFF3F3F1);
  static const Color dhlRed = Color(0xFFD40511);
  static const Color dhlYellow = Color(0xFFFFCC00);
  static const Color grey = Color(0xFF6B6B6B);
  static const Color darkerText = Color(0xFF1A1A1A);
  static const Color lightText = Color(0xFF5C5C5C);

  // Dark-mode surfaces: neutral elevation scale (unchanged shape, just no
  // longer tied to the old blue brand).
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkOnSurface = Color(0xFFF0F0F0);
  static const Color darkOnSurfaceVariant = Color(0xFFB8B8B8);

  static const String fontFamily = 'WorkSans';

  static const double cardRadius = 12;
  static const double controlRadius = 8;

  static final ColorScheme _lightScheme =
      ColorScheme.fromSeed(
        seedColor: dhlRed,
        brightness: Brightness.light,
      ).copyWith(
        primary: dhlRed,
        onPrimary: white,
        primaryContainer: Color.lerp(white, dhlRed, 0.12),
        onPrimaryContainer: dhlRed,
        secondary: dhlYellow,
        onSecondary: const Color(0xFF241C00),
        secondaryContainer: dhlYellow,
        onSecondaryContainer: const Color(0xFF241C00),
        surface: white,
        onSurface: darkerText,
        surfaceContainerHighest: const Color(0xFFEFEFEC),
        onSurfaceVariant: lightText,
        outline: grey.withValues(alpha: 0.35),
        outlineVariant: grey.withValues(alpha: 0.15),
        error: const Color(0xFFD32F2F),
      );

  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: dhlRed,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFFF5A64),
        onPrimary: const Color(0xFF3A0007),
        primaryContainer: Color.lerp(darkSurface, dhlRed, 0.35),
        onPrimaryContainer: const Color(0xFFFFD9DB),
        secondary: dhlYellow,
        onSecondary: const Color(0xFF241C00),
        secondaryContainer: dhlYellow,
        onSecondaryContainer: const Color(0xFF241C00),
        surface: darkSurface,
        onSurface: darkOnSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkOnSurfaceVariant.withValues(alpha: 0.35),
        outlineVariant: darkOnSurfaceVariant.withValues(alpha: 0.15),
        error: const Color(0xFFEF9A9A),
      );

  static const AppSemanticColors _lightSemantic = AppSemanticColors(
    success: Color(0xFF2E7D32),
    warning: Color(0xFFEF6C00),
    info: Color(0xFF6A1B9A),
    chartPalette: [Color(0xFF6E86D6), Color(0xFFE85C87), Color(0xFFE0A63A)],
  );

  static const AppSemanticColors _darkSemantic = AppSemanticColors(
    success: Color(0xFF6FCB73),
    warning: Color(0xFFFFB74D),
    info: Color(0xFFCE93D8),
    chartPalette: [Color(0xFF8CA1EA), Color(0xFFF288A6), Color(0xFFEDC06B)],
  );

  static TextTheme _textTheme({
    required Color primaryText,
    required Color secondaryText,
  }) {
    return TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: 0.3,
        height: 1.15,
        color: primaryText,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 24,
        letterSpacing: 0.2,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 18,
        letterSpacing: 0.15,
        color: primaryText,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: primaryText,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: secondaryText,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: primaryText,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: primaryText,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: secondaryText,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: primaryText,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: secondaryText,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        color: secondaryText,
      ),
    );
  }

  static ThemeData get light => _build(
    scheme: _lightScheme,
    scaffoldBackground: background,
    semantic: _lightSemantic,
    textTheme: _textTheme(primaryText: darkerText, secondaryText: lightText),
  );

  static ThemeData get dark => _build(
    scheme: _darkScheme,
    scaffoldBackground: darkBackground,
    semantic: _darkSemantic,
    textTheme: _textTheme(
      primaryText: darkOnSurface,
      secondaryText: darkOnSurfaceVariant,
    ),
  );

  static ThemeData _build({
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required AppSemanticColors semantic,
    required TextTheme textTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      fontFamily: fontFamily,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[semantic],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 2,
        margin: EdgeInsets.zero,
        shadowColor: scheme.shadow.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        selectedColor: scheme.primary,
        selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? scheme.primary
                  : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? scheme.primary.withValues(alpha: 0.4)
                  : scheme.surfaceContainerHighest,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        scrimColor: Colors.black.withValues(alpha: 0.4),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
      ),
    );
  }
}
