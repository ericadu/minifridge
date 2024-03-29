import 'dart:math';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = const Color(0xfff15f23); 
  static const Color orange = const Color(0xfffaae33);

  static const Color themeColor = const Color(0xff8fd4de);

  static final ThemeData lightTheme = ThemeData(
    // primarySwatch: Colors.green,
    // accentColor: Colors.teal[400],
    accentColor: themeColor,
    primarySwatch: generateMaterialColor(themeColor),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      shadowColor: themeColor
    ),
    colorScheme: ColorScheme.light(
      primary: themeColor,
      secondary: themeColor
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.fixed
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );


static MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

static int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

static Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

static int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

static Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
}