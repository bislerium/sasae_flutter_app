import 'package:flutter/material.dart';

class InternetConnectionProvider with ChangeNotifier {
  bool _isConnected;

  InternetConnectionProvider() : _isConnected = false;

  set setIsConnected(bool isConnected) => _isConnected = isConnected;
  bool get getIsConnected => _isConnected;
}
