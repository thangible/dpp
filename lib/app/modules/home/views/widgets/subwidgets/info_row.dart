import 'package:flutter/material.dart';
import 'package:dpp/app/modules/home/views/widgets/subwidgets/macronutrient_bar.dart';
import 'package:dpp/config/utils/hex_color.dart';

class InfoRowWidget extends StatelessWidget {
  final double animationValue;
  
  const InfoRowWidget({
    super.key,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextWithBarWidget(
            label: 'Recycled from scrap',
            remaining: '60%',
            color: HexColor('#F56E98'),
            progress: 1.2,
            animationValue: animationValue,
          ),
        ),
        Expanded(
          child: TextWithBarWidget(
            label: 'Recycled from others',
            remaining: '30%',
            color: HexColor('#F1B440'),
            progress: 2.0,
            animationValue: animationValue,
          ),
        ),
        Expanded(
          child: TextWithBarWidget(
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