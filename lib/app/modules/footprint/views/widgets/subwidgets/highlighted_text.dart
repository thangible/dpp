import 'package:flutter/material.dart';

class HighlightedTextWithIConWidget extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String iconPath;
  final Color color;
  final double animationValue;

  const HighlightedTextWithIConWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.iconPath,
    required this.color,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          height: 48,
          width: 2,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 28, height: 28, child: Image.asset(iconPath)),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 3),
                    child: SizedBox(
                      width: 50, // Fixed width for value
                      child: Text(
                        value,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right, // Right align the text
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      unit,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
