import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const Color notWhite = Color(0xFFEDF0F2);
  // static const Color nearlyWhite = Color(0xFFFEFEFE);
  // static const Color white = Color(0xFFFFFFFF);
  // static const Color nearlyBlack = Color(0xFF213333);
  // static const Color grey = Color(0xFF3A5160);
  // static const Color dark_grey = Color(0xFF313A44);

  // static const Color darkText = Color(0xFF253840);
  // static const Color darkerText = Color(0xFF17262A);
  // static const Color lightText = Color(0xFF4A6572);
  // static const Color deactivatedText = Color(0xFF767676);
  // static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  // static const Color spacer = Color(0xFFF2F2F2);
  // static const String fontName = 'WorkSans';
  
  

  static const TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  // static const TextTheme textTheme = TextTheme(
  //   displayLarge: display1,
  //   headlineSmall: headline,
  //   titleLarge: title,
  //   titleMedium: subtitle,
  //   bodyMedium: body2,
  //   bodyLarge: body1,
  //   bodySmall: caption,
  // );

  // static const TextStyle display1 = TextStyle( // h4 -> display1
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 36,
  //   letterSpacing: 0.4,
  //   height: 0.9,
  //   color: darkerText,
  // );

  // static const TextStyle headline = TextStyle( // h5 -> headline
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 24,
  //   letterSpacing: 0.27,
  //   color: darkerText,
  // );

  // static const TextStyle title = TextStyle( // h6 -> title
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 16,
  //   letterSpacing: 0.18,
  //   color: darkerText,
  // );

  // static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.w400,
  //   fontSize: 14,
  //   letterSpacing: -0.04,
  //   color: darkText,
  // );

  // static const TextStyle body2 = TextStyle( // body1 -> body2
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.w400,
  //   fontSize: 14,
  //   letterSpacing: 0.2,
  //   color: darkText,
  // );

  // static const TextStyle body1 = TextStyle( // body2 -> body1
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.w400,
  //   fontSize: 16,
  //   letterSpacing: -0.05,
  //   color: darkText,
  // );

  // static const TextStyle caption = TextStyle( // Caption -> caption
  //   fontFamily: fontName,
  //   fontWeight: FontWeight.w400,
  //   fontSize: 12,
  //   letterSpacing: 0.2,
  //   color: lightText, // was lightText
  // );

  
  
}
