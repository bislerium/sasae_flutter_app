import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';
import 'package:shake/shake.dart';
import 'package:wiredash/wiredash.dart';

class StartupConfigProvider with ChangeNotifier {
  final JsonStore _jsonStore;
  final String _themeKey;
  final String _themeModeKey;
  final String _themeColorKey;
  final String _isDemoKey;
  final String _shakeToFeedbackKey;

  // Default Value
  StartupConfigProvider()
      : _jsonStore = JsonStore(),
        _themeKey = 'theme',
        _themeModeKey = 'theme-mode',
        _themeColorKey = 'theme-color',
        _isDemoKey = 'is-demo',
        _shakeToFeedbackKey = 'shake-to-feedback',
        _themeMode = ThemeMode.system,
        _brandingColor = Colors.deepPurple,
        _shakeToFeedback = true {
    _isDemo = false;
  }

//------------------------------------------------------------------------------

  ThemeMode _themeMode;

  ThemeMode get getThemeMode => _themeMode;

  set setThemeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    flushStartupConfig();
    notifyListeners();
  }

//------------------------------------------------------------------------------

  Color _brandingColor;

  Color get getBrandingColor => _brandingColor;

  set setBrandingColor(Color brandingColor) {
    if (_brandingColor == brandingColor) return;
    _brandingColor = brandingColor;
    flushStartupConfig();
    notifyListeners();
  }

//------------------------------------------------------------------------------

  static late bool _isDemo;

  static bool get getIsDemo => _isDemo;

  void toogleDemo(BuildContext context) {
    _isDemo = !_isDemo;
    showSnackBar(
      context: context,
      message: '${_isDemo ? 'Demo' : 'Live'} mode',
      errorSnackBar: _isDemo,
    );
    flushStartupConfig();
  }

//------------------------------------------------------------------------------

  bool _shakeToFeedback;

  bool get getShakeToFeedback => _shakeToFeedback;

  late final ShakeDetector? _detector;

  ShakeDetector? get getShakeDetector => _detector;

  late BuildContext _context;

  set setWireDashBuildContext(BuildContext value) => _context = value;

  void initShakeDetector() {
    _detector = ShakeDetector.waitForStart(
        minimumShakeCount: 2,
        onPhoneShake: () {
          Wiredash.of(_context).show(inheritMaterialTheme: true);
        });
    _toggleShakeListening();
  }

  void _toggleShakeListening() => _shakeToFeedback
      ? _detector?.startListening()
      : _detector?.stopListening();

  void setShakeToFeedback(bool value) {
    if (value != _shakeToFeedback) {
      _shakeToFeedback = value;
      _toggleShakeListening();
      flushStartupConfig();
    }
  }

//------------------------------------------------------------------------------

  Future<void> flushStartupConfig() async {
    await _jsonStore.setItem(
      _themeKey,
      {
        _themeModeKey: _themeMode.index,
        _themeColorKey: _brandingColor.value,
        _isDemoKey: _isDemo,
        _shakeToFeedbackKey: _shakeToFeedback
      },
    );
  }

  Future<void> fetchStartupConfig() async {
    Map<String, dynamic>? themeJSON = await _jsonStore.getItem(_themeKey);
    if (themeJSON == null) return;
    _themeMode = ThemeMode.values[themeJSON[_themeModeKey]];
    _brandingColor = Color(themeJSON[_themeColorKey]);
    _isDemo = themeJSON[_isDemoKey];
    _shakeToFeedback = themeJSON[_shakeToFeedbackKey];
  }
}
