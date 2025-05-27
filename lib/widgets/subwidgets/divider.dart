import 'package:flutter/material.dart';
import 'package:dpp/styles/app_theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

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