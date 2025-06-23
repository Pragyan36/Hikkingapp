// lib/provider/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/font.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // Colors
  static const Color testAppColor = Color(0xFF010C80);
  static const Color lightGray = Color(0XFFF3F3F3);
  static const Color gray = Color(0xFFDEDEDE);
  static const Color darkGray = Color(0xFF3E3E3E);
  static const Color lightTextColor = Color(0xff131313);
  static const Color darkTextColor = Color(0xfff8f8f8);
  static const Color backgroundColor = Color(0xFFECF4FF);
  static const Color darkerBlack = Color(0xff060606);

  // Light Theme
  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: testAppColor,
    primaryColorDark: testAppColor,
    shadowColor: Colors.black,
    appBarTheme:
        const AppBarTheme(iconTheme: IconThemeData(color: testAppColor)),
    scaffoldBackgroundColor: backgroundColor,
    iconTheme: const IconThemeData(color: darkerBlack),
    fontFamily: Fonts.poppin,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: lightTextColor, fontWeight: FontWeight.bold, fontSize: 24),
      displayMedium: TextStyle(
          color: lightTextColor, fontWeight: FontWeight.bold, fontSize: 22),
      displaySmall: TextStyle(
          color: lightTextColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(fontSize: 18, color: lightTextColor),
      headlineSmall: TextStyle(color: lightTextColor, fontSize: 16),
      titleLarge: TextStyle(
          color: lightTextColor, fontSize: 14, fontWeight: FontWeight.w300),
      bodySmall: TextStyle(color: lightTextColor, fontSize: 8),
      titleSmall: TextStyle(color: lightTextColor, fontSize: 12),
      titleMedium: TextStyle(color: lightTextColor, fontSize: 10),
      labelLarge: TextStyle(color: lightTextColor, fontSize: 12),
      bodyLarge: TextStyle(fontSize: 12, color: lightTextColor),
      bodyMedium: TextStyle(fontSize: 10, color: lightTextColor),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

  // Dark Theme
  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: testAppColor,
    primaryColorDark: testAppColor,
    shadowColor: Colors.white,
    appBarTheme:
        const AppBarTheme(iconTheme: IconThemeData(color: testAppColor)),
    scaffoldBackgroundColor: darkGray,
    iconTheme: const IconThemeData(color: Colors.white),
    fontFamily: Fonts.poppin,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 24),
      displayMedium: TextStyle(
          color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 22),
      displaySmall: TextStyle(
          color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(fontSize: 18, color: darkTextColor),
      headlineSmall: TextStyle(color: darkTextColor, fontSize: 16),
      titleLarge: TextStyle(
          color: darkTextColor, fontSize: 14, fontWeight: FontWeight.w300),
      bodySmall: TextStyle(color: darkTextColor, fontSize: 8),
      titleSmall: TextStyle(color: darkTextColor, fontSize: 12),
      titleMedium: TextStyle(color: darkTextColor, fontSize: 10),
      labelLarge: TextStyle(color: darkTextColor, fontSize: 12),
      bodyLarge: TextStyle(fontSize: 12, color: darkTextColor),
      bodyMedium: TextStyle(fontSize: 10, color: darkTextColor),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: darkGray),
  );
}
