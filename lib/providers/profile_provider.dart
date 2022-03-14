import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _authP;

  User? _user;

  User? get userData => _user;

  set setAuthP(AuthProvider authP) => _authP = authP;

  Future<void> initFetchUser({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    switch (_authP.auth!.group) {
      case 'General':
        _user = await PeopleProvider.fetchPeople(
          isDemo: isDemo,
          auth: _authP.auth!,
        );
        break;
      case 'NGO':
        _user = await NGOProvider.fetchNGO(
          isDemo: isDemo,
          auth: _authP.auth!,
        );
        break;
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await initFetchUser();
  }
}
