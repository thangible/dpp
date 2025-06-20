import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/config/utils/hex_color.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/curl_painter.dart';



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
              color: AppTheme.white,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                width: 4,
                color: AppTheme.nearlyDarkBlue.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$currentValue',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    letterSpacing: 0.0,
                    color: AppTheme.nearlyDarkBlue,
                  ),
                ),
                Text(
                  'CO2 Emission',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: AppTheme.grey.withOpacity(0.5),
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
                AppTheme.nearlyDarkBlue,
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