import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _authP;
  late NGOProvider _ngoP;
  late PeopleProvider _peopleP;

  User? _user;

  User? get userData => _user;

  set setAuthP(AuthProvider authP) => _authP = authP;
  set setNGOP(NGOProvider ngoP) => _ngoP = ngoP;
  set setPeopleP(PeopleProvider peopleP) => _peopleP = peopleP;

  List<String> gender() => ['Male', 'Female', 'LGBTQ+'];

  Future<void> initFetchUser({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    switch (_authP.auth!.group) {
      case 'General':
        _user = await _peopleP.fetchPeople(isDemo: isDemo);
        break;
      case 'NGO':
        _user = await _ngoP.fetchNGO(isDemo: isDemo);
        break;
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await initFetchUser();
  }
}
