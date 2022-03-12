import 'dart:convert';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _authP;
  GeneralPeople? _people;

  GeneralPeople? get userData => _people;
  set setAuthP(AuthProvider auth) => _authP = auth;

  List<String> gender() => ['Male', 'Female', 'LGBTQ+'];

  void _randUser() {
    bool isVerified = faker.randomGenerator.boolean();
    _people = GeneralPeople(
      id: faker.randomGenerator.integer(1000),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      postedPosts: Set<int>.of(List.generate(faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      userName: faker.person.firstName(),
      fullName: faker.person.name(),
      group: faker.randomGenerator.element(['General', 'NGO']),
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

  Future<void> fetchUser({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (isDemo) {
      _randUser();
    } else {
      try {
        final response = await http.get(
          Uri.parse(
              '${getHostName()}$peopleEndpoint${_authP.auth!.profileID}/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${_authP.auth!.tokenKey}',
          },
        );
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(json.decode(response.body));
        }
        _people = GeneralPeople.fromAPIResponse(responseData);
      } catch (error) {
        _people = null;
      }
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await fetchUser();
  }
}
