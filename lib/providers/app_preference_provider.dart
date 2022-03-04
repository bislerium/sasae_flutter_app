import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class UserData {}

class AppPreferenceProvider extends ChangeNotifier {
  late bool _darkMode;
  SessionManager sessionManager;

  AppPreferenceProvider() : sessionManager = SessionManager();

  void initAppPreference() {
    // if (sessionManager.containsKey('darkmode')) {}
  }

  bool get getDarkMode => _darkMode;

  void toggleDarkMode([bool? toogle]) {
    _darkMode = toogle ?? !_darkMode;
    sessionManager.set('darkmode', _darkMode);
    notifyListeners();
  }
}
