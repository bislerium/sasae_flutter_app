import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default Value
  ThemeProvider()
      : _themeMode = ThemeMode.light,
        _brandingColor = Colors.deepPurple;

  ThemeMode _themeMode;

  ThemeMode get getThemeMode => _themeMode;

  set setThemeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    notifyListeners();
  }

  Color _brandingColor;

  Color get getBrandingColor => _brandingColor;

  set setBrandingColor(Color brandingColor) {
    if (_brandingColor == brandingColor) return;
    _brandingColor = brandingColor;
    notifyListeners();
  }
}
