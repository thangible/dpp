import 'package:flutter/material.dart';
import 'package:dpp/config/theme/app_theme.dart';


class TextWithBarWidget extends StatelessWidget {
  final String label;
  final String remaining;
  final Color color;
  final double progress;
  final double animationValue;

  const TextWithBarWidget({
    super.key,
    required this.label,
    required this.remaining,
    required this.color,
    required this.progress,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: -0.2,
            color: AppTheme.grey.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 4,
            width: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Row(
              children: [
                Container(
                  width: ((70 / progress) * animationValue),
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      color,
                      color.withOpacity(0.5),
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            remaining,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppTheme.darkText ,
            ),
          ),
        ),
      ],
    );
  }
}