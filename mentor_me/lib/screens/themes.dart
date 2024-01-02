import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  shadowColor: Colors.grey.withOpacity(0.2),
  primaryColor: const Color.fromARGB(255, 56, 107, 246),
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 56, 107, 246),
    onPrimary: Colors.black,
    background: Colors.white,
    surface: Color.fromARGB(255, 236, 241, 253),
  ),
);

final ThemeData darkTheme = ThemeData(
  shadowColor: Colors.grey.withOpacity(0.1),
  primaryColor: Color.fromARGB(251, 57, 126, 255),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 56, 107, 246),
    onPrimary: Colors.white,
    background: Color(0xFF121212),
    surface: Color.fromARGB(186, 16, 26, 46),
  ),
);
