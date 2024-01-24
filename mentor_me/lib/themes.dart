import 'package:flutter/material.dart';

// custom themes provided to the app

// light theme
final ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
  ),
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

// dark theme
final ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF121212),
  ),
  shadowColor: Colors.grey.withOpacity(0),
  primaryColor: Color.fromARGB(251, 57, 126, 255),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 56, 107, 246),
    onPrimary: Colors.white,
    background: Color(0xFF121212),
    surface: Color.fromARGB(186, 16, 26, 46),
    tertiaryContainer: Color.fromARGB(255, 82, 82, 82),
    tertiary: Colors.white,
    secondary: Color.fromARGB(255, 48, 48, 48),
  ),
);

// custom decoration for containers
BoxDecoration boxDecoration(ThemeData theme, double radius) => BoxDecoration(
      color: theme.colorScheme.tertiaryContainer,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor,
          spreadRadius: 5,
          blurRadius: 10,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );

// custom decoration for input fields
InputDecoration inputDecoration(
        ThemeData theme, double radius, String? hintText) =>
    InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
      // contentPadding: const EdgeInsets.all(16.0),
      filled: true,
      fillColor: theme.colorScheme.tertiaryContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
    );

// custom decoration for dropdown fields
InputDecoration inputDropDownDecoration(
        ThemeData theme, double radius, String? hintText) =>
    InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
      // contentPadding: const EdgeInsets.all(16.0),
      filled: true,
      fillColor: theme.colorScheme.tertiaryContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
