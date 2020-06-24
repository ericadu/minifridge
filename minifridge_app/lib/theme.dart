import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Colors.white;

  static const Color themeColor = const Color(0xff8fd4de);

  static final ThemeData lightTheme = ThemeData(
    // primarySwatch: Colors.green,
    appBarTheme: AppBarTheme(
      color: themeColor
    ),
    colorScheme: ColorScheme.light(
      primary: themeColor,
      secondary: themeColor
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}