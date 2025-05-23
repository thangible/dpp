import 'package:flutter/material.dart';
import 'package:dpp/fitness_app/fitness_app_theme.dart';
import 'package:dpp/dpp_cards/widgets/curl_painter.dart';
import 'package:dpp/utils/hex_color.dart';


class CustomCircularProgressIndicator extends StatelessWidget {
  final double animationValue;
  final double currentValue;
  
  const CustomCircularProgressIndicator({
    super.key,
    required this.animationValue,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children:  <Widget> [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: FitnessAppTheme.white,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                width: 4,
                color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$currentValue',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    letterSpacing: 0.0,
                    color: FitnessAppTheme.nearlyDarkBlue,
                  ),
                ),
                Text(
                  'CO2 Emission',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: FitnessAppTheme.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomPaint(
            painter: CurvePainter(
              colors: [
                FitnessAppTheme.nearlyDarkBlue,
                HexColor("#8A98E8"),
                HexColor("#8A98E8")
              ],
              angle: 140 + (360 - 140) * (1.0 - animationValue),
            ),
            child: const SizedBox(width: 108, height: 108),
          ),
        )
      ],
    );
  }
}