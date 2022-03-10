import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _auth;
  User? _user;

  User? get userData => _user;
  set setAuth(AuthProvider auth) => _auth = auth;

  List<String> gender() => ['Male', 'Female', 'LGBTQ+'];

  void _randUser() {
    bool isVerified = faker.randomGenerator.boolean();
    _user = User(
      id: faker.randomGenerator.integer(1000),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      numOfPosts: faker.randomGenerator.integer(1000),
      userName: faker.person.firstName(),
      fullName: faker.person.name(),
      gender: faker.randomGenerator.element(gender()),
      birthDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.streetAddress(),
      phoneNumber: faker.phoneNumber.us(),
      email: faker.internet.email(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      citizenshipPhoto: isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Future<void> fetchUser({bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (isDemo) _randUser();
    print(_auth.tokenKey);
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await fetchUser();
  }
}
