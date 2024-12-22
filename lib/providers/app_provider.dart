import 'package:flutter/material.dart';
import 'package:flutter_product/constants/shared_prefs_keys.dart';
import 'package:flutter_product/helpers/shared_prefs_helper.dart';

class AppProvider extends ChangeNotifier {
  final prefs = SharedPrefsHelper().prefs;

  // Default initial app type and dark mode setting
  bool _darkMode = false;

  // Getter for appType and darkMode
  bool get darkMode => _darkMode;

  // Setter for dark mode
  void setDarkMode(bool value) async {
    if (_darkMode != value) {
      _darkMode = value;
      await _saveDarkModeToPrefs(value); // Save to SharedPreferences
      notifyListeners();
    }
  }

  // Initialize the provider by loading AppType and darkMode from SharedPreferences
  Future<void> initialize() async {
    _darkMode = await _getDarkModeFromPrefs(); // Load dark mode setting
    notifyListeners();
  }

  // Save darkMode to SharedPreferences
  Future<void> _saveDarkModeToPrefs(bool value) async {
    await prefs?.setBool(SharedPrefsKeys.isDarkMode, value);
  }

  // Retrieve darkMode setting from SharedPreferences
  Future<bool> _getDarkModeFromPrefs() async {
    return prefs?.getBool(SharedPrefsKeys.isDarkMode) ?? false;
  }
}
