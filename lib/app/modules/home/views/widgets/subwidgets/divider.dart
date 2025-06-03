import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';

class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}