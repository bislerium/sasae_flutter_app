import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

class StartupProvider with ChangeNotifier {
  final JsonStore _jsonStore;
  final String _themeKey;
  final String _themeModeKey;
  final String _themeColorKey;
  final String _isDemoKey;
  static late bool _isDemo;

  // Default Value
  StartupProvider()
      : _jsonStore = JsonStore(),
        _themeKey = 'theme',
        _themeModeKey = 'theme-mode',
        _themeColorKey = 'theme-color',
        _isDemoKey = 'is-demo',
        _themeMode = ThemeMode.system,
        _brandingColor = Colors.deepPurple {
    _isDemo = false;
  }

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

  static bool get getIsDemo => _isDemo;

  void toogleDemo(BuildContext context) {
    _isDemo = !_isDemo;
    showSnackBar(
      context: context,
      message: '${_isDemo ? 'Demo' : 'Live'} mode',
      errorSnackBar: _isDemo,
    );
    flushTheme();
  }

  Future<void> flushTheme() async {
    await _jsonStore.setItem(
      _themeKey,
      {
        _themeModeKey: _themeMode.index,
        _themeColorKey: _brandingColor.value,
        _isDemoKey: _isDemo,
      },
    );
  }

  Future<void> fetchTheme() async {
    Map<String, dynamic>? themeJSON = await _jsonStore.getItem(_themeKey);
    if (themeJSON == null) return;
    _themeMode = ThemeMode.values[themeJSON[_themeModeKey]];
    _brandingColor = Color(themeJSON[_themeColorKey]);
    _isDemo = themeJSON[_isDemoKey];
    notifyListeners();
  }
}
