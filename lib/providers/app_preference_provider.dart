import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class UserData {}

class AppPreferenceProvider extends ChangeNotifier {
  late bool _darkMode;
  late SessionManager sessionManager;

  AppPreferenceProvider() {
    sessionManager = SessionManager();
    _darkMode = false;
    initAppPreference();
  }

  Future<void> initAppPreference() async {
    var value = await sessionManager.get('darkmode');
    if (value != null && _darkMode != value) {
      _darkMode = value;
      notifyListeners();
    }
  }

  bool get darkMode => _darkMode;

  void toggleDarkMode([bool? toogle]) {
    _darkMode = toogle ?? !_darkMode;
    sessionManager.set('darkmode', _darkMode);
    notifyListeners();
  }
}
