import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';

class ThemeProvider with ChangeNotifier {
  final JsonStore _jsonStore;
  final String _themeKey;
  final String _themeModeKey;
  final String _themeColorKey;

  // Default Value
  ThemeProvider()
      : _jsonStore = JsonStore(),
        _themeKey = 'theme',
        _themeModeKey = 'theme-mode',
        _themeColorKey = 'theme-color',
        _themeMode = ThemeMode.light,
        _brandingColor = Colors.deepPurple;

  ThemeMode _themeMode;

  ThemeMode get getThemeMode => _themeMode;

  set setThemeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    flushTheme();
    notifyListeners();
  }

  Color _brandingColor;

  Color get getBrandingColor => _brandingColor;

  set setBrandingColor(Color brandingColor) {
    if (_brandingColor == brandingColor) return;
    _brandingColor = brandingColor;
    flushTheme();
    notifyListeners();
  }

  Future<void> flushTheme() async {
    await _jsonStore.setItem(
      _themeKey,
      {
        _themeModeKey: _themeMode.index,
        _themeColorKey: _brandingColor.value,
      },
    );
  }

  Future<void> fetchTheme() async {
    Map<String, dynamic>? themeJSON = await _jsonStore.getItem(_themeKey);
    if (themeJSON == null) return;
    _themeMode = ThemeMode.values[themeJSON[_themeModeKey]];
    _brandingColor = Color(themeJSON[_themeColorKey]);
    notifyListeners();
  }
}
