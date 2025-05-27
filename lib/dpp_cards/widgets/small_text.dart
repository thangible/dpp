import 'package:flutter/material.dart';
import 'package:dpp/styles/dpp_app_theme.dart';
import 'package:dpp/utils/hex_color.dart';

class SmallText extends StatelessWidget {
  final String value;
  final String label;

  const SmallText({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: FitnessAppTheme.darkText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: FitnessAppTheme.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
