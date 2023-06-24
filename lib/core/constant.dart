import 'package:flutter/material.dart';

const Color analogousColor1 = Color(0xFF6CC7D6);
const Color analogousColor2 = Color(0xFF6CDBB4);
const Color analogousColor3 = Color(0xFFA6D66C);
const Color errorColor = Color(0xFFD32F2F);
// Analogous Palette
const Color white = Color(0xFFffffff);
const Color mainColor = Color(0xFF6C9DD6);
const Color darkerColor = Color.fromARGB(255, 37, 72, 112);
const Color formFieldBorder = Color.fromARGB(255, 192, 192, 200);
final borderRadius = BorderRadius.circular(10);
const Color black = Color.fromARGB(255, 0, 0, 0);
const String interFontFamily = 'Inter';

// Create the ThemeData object
final ThemeData myTheme = ThemeData(
  // Define the colors for the theme
  primaryColor: mainColor,
  scaffoldBackgroundColor: Colors.white,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: mainColor.withOpacity(0.4),
    selectionHandleColor: mainColor,
  ),

  // Define the text theme for the theme
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontFamily: interFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 32,
      color: darkerColor,
    ),
    headlineSmall: TextStyle(
      fontFamily: interFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: darkerColor,
    ),
    bodyLarge: TextStyle(
      fontFamily: interFontFamily,
      fontSize: 16,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: interFontFamily,
      fontSize: 14,
      color: Colors.black54,
    ),
    bodySmall: TextStyle(
      fontFamily: interFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: white)),
  colorScheme: const ColorScheme(
      onSurface: darkerColor,
      surface: darkerColor,
      onBackground: mainColor,
      onError: errorColor,
      error: errorColor,
      secondary: darkerColor,
      onSecondary: darkerColor,
      onPrimary: mainColor,
      background: Colors.white,
      brightness: Brightness.light,
      primary: mainColor),
);
final ElevatedButtonThemeData myElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: mainColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
);
