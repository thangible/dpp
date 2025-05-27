import 'package:flutter/material.dart';
import 'package:dpp/styles/app_theme.dart';

const EdgeInsets cardPadding = EdgeInsets.only(
  left: 24,
  right: 24,
  top: 16,
  bottom: 18,
);

final BoxDecoration cardDecoration = BoxDecoration(
  color: AppTheme.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(8.0),
    bottomLeft: Radius.circular(8.0),
    bottomRight: Radius.circular(8.0),
    topRight: Radius.circular(68.0),
  ),
  boxShadow: [
    BoxShadow(
      color: AppTheme.grey.withOpacity(0.2),
      offset: Offset(1.1, 1.1),
      blurRadius: 10.0,
    ),
  ],
);

Matrix4 buildCardTranslation(double animationValue) {
  return Matrix4.translationValues(
    0.0,
    30 * (1.0 - animationValue),
    0.0,
  );
}