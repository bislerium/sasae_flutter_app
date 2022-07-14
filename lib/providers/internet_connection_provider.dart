import 'package:flutter/material.dart';

class InternetConnetionProvider with ChangeNotifier {
  bool _isConnected;

  InternetConnetionProvider() : _isConnected = false;

  set setIsConnected(bool isConnected) => _isConnected = isConnected;
  bool get getIsConnected => _isConnected;
}
