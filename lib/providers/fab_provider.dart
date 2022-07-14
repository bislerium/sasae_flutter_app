import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';

class ProfileSettingFABProvider with ChangeNotifier {
  bool _showFAB;
  int _tabIndex;
  UserType? _userType;

  ProfileSettingFABProvider()
      : _showFAB = false,
        _tabIndex = 0;

  bool get getShowFAB => _showFAB;
  set setTabIndex(int tabIndex) => _tabIndex = tabIndex;
  set setUserType(UserType userType) => _userType = userType;

  set setShowFAB(bool show) {
    if (_showFAB != show) {
      if (_userType == null || _tabIndex == 1 || _userType == UserType.ngo) {
        _showFAB = false;
      } else {
        _showFAB = show;
      }
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

class DonationFABProvider with ChangeNotifier {
  bool _showFAB;
  int _tabIndex;
  bool _ngoVerified;

  DonationFABProvider()
      : _showFAB = false,
        _tabIndex = 0,
        _ngoVerified = false;

  bool get getShowFAB => _showFAB;
  set setTabIndex(int tabIndex) => _tabIndex = tabIndex;
  set setNGOVerified(bool ngoVerified) => _ngoVerified = ngoVerified;

  set setShowFAB(bool show) {
    var value = show;
    if (_tabIndex == 1 || _ngoVerified == false) {
      value = false;
    }
    if (_showFAB != value) {
      _showFAB = value;
      notifyListeners();
    }
  }

  void resetFAB() {
    _showFAB = false;
    _tabIndex = 0;
    _ngoVerified = false;
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

class NotificationActionFABProvider with ChangeNotifier {
  bool _showFAB;

  NotificationActionFABProvider() : _showFAB = false;

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

enum FABType { editProfile, donation }
