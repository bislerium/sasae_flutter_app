import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class InternetConnetionProvider with ChangeNotifier {
  bool _isConnected;

  InternetConnetionProvider() : _isConnected = false;

  set setIsConnected(bool isConnected) => _isConnected = isConnected;
  bool get getIsConnected => _isConnected;

  bool Function() getConnectionStatusCallBack(BuildContext context) => () {
        if (!_isConnected) {
          showSnackBar(
              context: context,
              icon: Icons.cloud_off,
              message: 'No internet connection',
              errorSnackBar: true);
        }
        return demo ? true : _isConnected;
      };
}
