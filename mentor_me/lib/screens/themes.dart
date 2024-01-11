import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  shadowColor: Colors.grey.withOpacity(0.2),
  primaryColor: const Color.fromARGB(255, 56, 107, 246),
  colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 56, 107, 246),
      onPrimary: Colors.black,
      background: Colors.white,
      surface: Color.fromARGB(255, 236, 241, 253),
      tertiaryContainer: Colors.white,
      tertiary: Colors.black,
      secondary: Color.fromARGB(255, 48, 48, 48)),
);

final ThemeData darkTheme = ThemeData(
  shadowColor: Colors.grey.withOpacity(0),
  primaryColor: Color.fromARGB(251, 57, 126, 255),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 56, 107, 246),
    onPrimary: Colors.white,
    background: Color(0xFF121212),
    surface: Color.fromARGB(186, 16, 26, 46),
    tertiaryContainer: Color.fromARGB(255, 49, 49, 49),
    tertiary: Colors.white,
    secondary: Color.fromARGB(255, 48, 48, 48),
  ),
);
