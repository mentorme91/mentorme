import 'package:flutter/material.dart';
import 'themes.dart';

class MyThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  void switchMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
