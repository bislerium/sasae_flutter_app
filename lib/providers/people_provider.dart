import 'dart:convert';
import 'dart:io';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';

class PeopleProvider with ChangeNotifier {
  late AuthProvider _authP;
  People? _people;

  People? get peopleData => _people;
  set setAuthP(AuthProvider auth) => _authP = auth;

  static People randPeople() {
    bool isVerified = faker.randomGenerator.boolean();
    return People(
      id: faker.randomGenerator.integer(1000),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      postedPosts: Set<int>.of(List.generate(faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      username: faker.person.firstName(),
      fullname: faker.person.name(),
      gender: faker.randomGenerator.element(['Male', 'Female', 'LGBTQ+']),
      birthDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.streetAddress(),
      phone: faker.phoneNumber.us(),
      email: faker.internet.email(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      citizenshipPhoto: isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  //Used to fetch people data per screen. Will fetch logged in user data if peopleID not given.
  Future<void> initFetchPeople({int? peopleID}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    _people = await fetchPeople(peopleID: peopleID, auth: _authP.auth!);
    notifyListeners();
  }

  Future<void> refreshUser({int? peopleID}) async {
    await initFetchPeople(peopleID: peopleID);
  }

  //Always nullify the _people attribute on disposing the screen
  void nullifyPeople() => _people = null;

  Future<bool> registerPeople({
    required String username,
    required String email,
    required String password,
    required String fullname,
    required DateTime dob,
    required String gender,
    required String phone,
    required String address,
    XFile? displayPicture,
    XFile? citizenshipPhoto,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${getHostName()}$peopleAddEndpoint'));

      request.fields.addAll({
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullname,
        'date_of_birth': Jiffy(dob).format('yyyy-MM-dd'),
        'gender': gender,
        'phone': phone,
        'address': address,
      });
      if (displayPicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "display_picture", displayPicture.path));
      }

      if (citizenshipPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "citizenship_photo", citizenshipPhoto.path));
      }

      http.StreamedResponse response = await request.send();
      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updatePeople({
    required String email,
    required String fullname,
    required DateTime dob,
    required String gender,
    required String phone,
    required String address,
    XFile? displayPicture,
    XFile? citizenshipPhoto,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${getHostName()}$peopleUpdateEndpoint'));

      request.fields.addAll({
        'email': email,
        'full_name': fullname,
        'date_of_birth': Jiffy(dob).format('yyyy-MM-dd'),
        'gender': gender,
        'phone': phone,
        'address': address,
      });
      if (displayPicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "display_picture", displayPicture.path));
      }

      if (citizenshipPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "citizenship_photo", citizenshipPhoto.path));
      }

      http.StreamedResponse response = await request.send();
      if (response.statusCode >= 400) {
        throw HttpException(response.reasonPhrase!);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deletePeople() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
      };
      var request = http.Request(
          'DELETE', Uri.parse('${getHostName()}$peopleDeleteEndpoint'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  //Can be used for fetching multiple people data in parallel
  static Future<People?> fetchPeople({
    int? peopleID,
    required Auth auth,
    bool isDemo = false,
  }) async {
    if (isDemo) {
      return randPeople();
    } else {
      try {
        final response = await http.get(
          Uri.parse(
              '${getHostName()}$peopleEndpoint${peopleID ?? auth.profileID}/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${auth.tokenKey}',
          },
        );
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(json.decode(response.body));
        }
        return People.fromAPIResponse(responseData);
      } catch (error) {
        return null;
      }
    }
  }
}
