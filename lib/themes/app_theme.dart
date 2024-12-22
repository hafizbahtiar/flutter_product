import 'package:flutter/material.dart';
import 'package:flutter_product/themes/button_theme.dart';
import 'package:flutter_product/themes/color_theme.dart';
import 'package:flutter_product/themes/input_theme.dart';
import 'package:flutter_product/themes/tile_theme.dart';

ThemeData appThemeData(BuildContext context, bool isDarkMode) {
  // Define color scheme based on mode
  final colorScheme = isDarkMode ? darkColorScheme() : lightColorScheme();

  // Create and return the ThemeData based on the current mode
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    inputDecorationTheme: inputDecoTheme(isDarkMode),
    iconButtonTheme: iconButtonTheme(isDarkMode),
    listTileTheme: listTileTheme(isDarkMode),
    elevatedButtonTheme: elevatedButtonTheme(isDarkMode),
    filledButtonTheme: filledButtonTheme(isDarkMode),
    outlinedButtonTheme: outlinedButtonTheme(isDarkMode),
    textButtonTheme: textButtonTheme(isDarkMode),
  );
}
