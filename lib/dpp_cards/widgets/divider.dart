import 'package:flutter/material.dart';
import 'package:dpp/fitness_app/fitness_app_theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: FitnessAppTheme.background,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}