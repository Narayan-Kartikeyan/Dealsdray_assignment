
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 248, 68, 101);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color accentColor = Color(0xFFFFC107);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black,fontFamily: "roboto",fontSize:32),
    bodyMedium: TextStyle(color: Colors.black,fontFamily:"roboto"),
    bodySmall: TextStyle(color: Colors.black54),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
  );
}