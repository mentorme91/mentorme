import 'package:flutter/material.dart';
import 'themes.dart';

/// class [MyThemeProvider] provides the theme of the appp to the screens
///  It controls the changing from dark mode to light mode in the [switchMode] function
class MyThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  // changes mode (light to/from dark)
  void switchMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
