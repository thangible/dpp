import 'package:flutter/material.dart';
import 'package:dpp/legacy/curl_painter.dart';

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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                width: 4,
                color: colors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$currentValue',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    color: colors.primary,
                  ),
                ),
                Text(
                  'CO2 Emission',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
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
                colors.primary,
                colors.secondary,
                colors.secondary,
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