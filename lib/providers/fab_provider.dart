import 'package:flutter/cupertino.dart';

class FABProvider with ChangeNotifier {
  Widget? _fabActionHandler;

  Widget? get getFABActionHandler => _fabActionHandler;

  set setFABActionHandler(Widget? handler) {
    print(handler);
    if (_fabActionHandler != handler) {
      _fabActionHandler = handler;
      print(handler);
      notifyListeners();
    }
  }
}
