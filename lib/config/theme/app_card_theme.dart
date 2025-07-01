import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';

class AppCardTheme {
  AppCardTheme._();

  // Identifier
  static const TextStyle identifierTextStyle = TextStyle(
    fontFamily: AppTheme.fontName,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.5,
    color: AppTheme.lightText,
  );
}
