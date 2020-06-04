import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.teal[500]
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}