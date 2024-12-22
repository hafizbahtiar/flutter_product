import 'package:flutter/material.dart';
import 'package:flutter_product/themes/app_pallete.dart';

ListTileThemeData listTileTheme(bool isDarkMode) {
  return ListTileThemeData(
    selectedTileColor: isDarkMode ? AppPallete.borderDark : AppPallete.borderLight,
  );
}
