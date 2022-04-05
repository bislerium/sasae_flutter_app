import 'package:flutter/material.dart';

class ProfileSettingFABProvider with ChangeNotifier {
  bool _showFAB;

  ProfileSettingFABProvider() : _showFAB = false;

  bool get getShowFAB => _showFAB;

  set setShowFAB(bool show) {
    if (_showFAB != show) {
      _showFAB = show;
      notifyListeners();
    }
  }

  VoidCallback? _onPressedHandler;

  VoidCallback? get getOnPressedHandler => _onPressedHandler;

  set setOnPressedHandler(VoidCallback? handler) {
    if (_onPressedHandler != handler) {
      _onPressedHandler = handler;
      notifyListeners();
    }
  }
}

class PostFABProvider with ChangeNotifier {
  bool _showFAB;

  PostFABProvider() : _showFAB = false;

  bool get getShowFAB => _showFAB;

  set setShowFAB(bool show) {
    if (_showFAB != show) {
      _showFAB = show;
      notifyListeners();
    }
  }

  VoidCallback? _onPressedHandler;

  VoidCallback? get getOnPressedHandler => _onPressedHandler;

  set setOnPressedHandler(VoidCallback? handler) {
    if (_onPressedHandler != handler) {
      _onPressedHandler = handler;
      notifyListeners();
    }
  }
}

class LogoutFABProvider with ChangeNotifier {
  bool _showFAB;

  LogoutFABProvider() : _showFAB = false;

  bool get getShowFAB => _showFAB;

  set setShowFAB(bool show) {
    if (_showFAB != show) {
      _showFAB = show;
      notifyListeners();
    }
  }

  VoidCallback? _onPressedHandler;

  VoidCallback? get getOnPressedHandler => _onPressedHandler;

  set setOnPressedHandler(VoidCallback? handler) {
    if (_onPressedHandler != handler) {
      _onPressedHandler = handler;
      notifyListeners();
    }
  }
}
