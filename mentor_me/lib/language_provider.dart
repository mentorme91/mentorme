import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _lang = 'English'; // Default language is English

  // Getter for lang property
  String get lang => _lang;

  // Method to change the value of lang
  void changeLanguage(String newLang) {
    _lang = newLang;
    notifyListeners();
  }
}