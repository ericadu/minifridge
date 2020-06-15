import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Colors.white;

  static const Color themeColor = const Color(0xff66a1ee);

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: themeColor
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}