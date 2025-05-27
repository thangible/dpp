import 'package:flutter/material.dart';
import 'package:dpp/widgets/subwidgets/macronutrient_bar.dart';
import 'package:dpp/styles/app_theme.dart';
import 'package:dpp/utils/hex_color.dart';

class MacronutrientRow extends StatelessWidget {
  final double animationValue;
  
  const MacronutrientRow({
    super.key,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MacronutrientBar(
            label: 'Recycled from scrap',
            remaining: '60%',
            color: HexColor('#F56E98'),
            progress: 1.2,
            animationValue: animationValue,
          ),
        ),
        Expanded(
          child: MacronutrientBar(
            label: 'Recycled from others',
            remaining: '30%',
            color: HexColor('#F1B440'),
            progress: 2.0,
            animationValue: animationValue,
          ),
        ),
        Expanded(
          child: MacronutrientBar(
            label: 'Virgin Material',
            remaining: '10%',
            color:  HexColor('#87A0E5'),
            progress: 1.2,
            animationValue: animationValue,
          ),
        ),
      ],
    );
  }
}