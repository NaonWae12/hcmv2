import 'package:flutter/material.dart';

import 'components/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode; // Getter for themeMode

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners about the theme change
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: AppColors.secondaryColor,
    primaryContainer: Colors.white,
    secondaryContainer: Color(0xFFF4F4F4),
    tertiaryContainer: AppColors.primaryColor,
    primary: AppColors.primaryColor,
    onPrimaryContainer: Colors.blue,
    // secondary: Color(0xFFF4F4F4),
    // tertiary: AppColors.primaryColor,
  ),
);
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.primaryColor,
      primaryContainer: Color(0xFF202124),
      secondaryContainer: Color(0xFF282A2D),
      tertiaryContainer: Color(0xFF3C4043),
      primary: AppColors.secondaryColor,
      onPrimaryContainer: AppColors.lightContainer,
      // secondary: Color(0xFF282A2D),
      // tertiary: Color(0xFF3C4043)
    ));
