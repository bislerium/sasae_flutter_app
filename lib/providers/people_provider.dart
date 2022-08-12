import 'dart:convert';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class PeopleProvider with ChangeNotifier {
  late AuthProvider _authP;
  PeopleModel? _people;

  PeopleModel? get peopleData => _people;
  set setAuthP(AuthProvider auth) => _authP = auth;

  static PeopleModel randPeople() {
    bool isVerified = faker.randomGenerator.boolean();
    return PeopleModel(
      id: faker.randomGenerator.integer(1000),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      postedPosts: Set<int>.of(List.generate(faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      username: faker.person.firstName(),
      fullName: faker.person.name(),
      gender: faker.randomGenerator.element(['Male', 'Female', 'LGBTQ+']),
      birthDate: faker.date.dateTime(
          minYear:
              DateTime.now().subtract(const Duration(days: 365 * 122)).year,
          maxYear:
              DateTime.now().subtract(const Duration(days: 365 * 16)).year),
      address: faker.address.streetAddress(),
      phone: faker.phoneNumber.us(),
      email: faker.internet.email(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      citizenshipPhoto: isVerified || faker.randomGenerator.boolean()
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  //Used to fetch people data per screen. Will fetch logged in user data if peopleID not given.
  Future<void> initFetchPeople({int? peopleID}) async {
    _people = await fetchPeople(peopleID: peopleID, auth: _authP.getAuth!);
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
    required String fullName,
    required DateTime dob,
    required String gender,
    required String phone,
    required String address,
    XFile? displayPicture,
    XFile? citizenshipPhoto,
  }) async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        return true;
      }
      final request = http.MultipartRequest(
          'POST', Uri.parse('${getHostName()}$peopleAddEndpoint'));

      request.fields.addAll({
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
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

      http.StreamedResponse response =
          await request.send().timeout(timeOutDuration);
      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  PeopleUpdateModel? _peopleUpdate;

  PeopleUpdateModel? get getPeopleUpdate => _peopleUpdate;

  void nullifyPeopleUpdate() => _peopleUpdate = null;

  Future<PeopleUpdateModel> _randPeopleUpdateModel() async =>
      PeopleUpdateModel()
        ..setFullName = faker.person.name()
        ..setAddress = faker.address.city()
        ..setBirthDate = faker.date.dateTime(
            minYear:
                DateTime.now().subtract(const Duration(days: 365 * 122)).year,
            maxYear:
                DateTime.now().subtract(const Duration(days: 365 * 16)).year)
        ..setDisplayPicture =
            await imageURLToXFile(faker.image.image(random: true))
        ..setGender =
            faker.randomGenerator.element(['Male', 'Female', 'LGBTQ+'])
        ..setEmail = faker.internet.email()
        ..setPhone = faker.phoneNumber.us()
        ..setCitizenshipPhoto =
            await imageURLToXFile(faker.image.image(random: true))
        ..setIsVerified = faker.randomGenerator.boolean();

  Future<void> retrieveUpdatePeople() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        _peopleUpdate = await _randPeopleUpdateModel();
      } else {
        final request = http.MultipartRequest(
            'GET', Uri.parse('${getHostName()}$peopleDetailEndpoint'));

        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        };

        request.headers.addAll(headers);

        http.StreamedResponse response =
            await request.send().timeout(timeOutDuration);

        String responseBody = await response.stream.bytesToString();

        if (response.statusCode >= 400) {
          throw HttpException(responseBody);
        }

        _peopleUpdate =
            PeopleUpdateModel.fromAPIResponse(json.decode(responseBody));

        String? citizenshipPhotoLink = _peopleUpdate!.getCitizenshipPhotoLink;
        String? displayPictureLink = _peopleUpdate!.getDisplayPictureLink;

        if (displayPictureLink != null) {
          _peopleUpdate!.setDisplayPicture =
              await imageURLToXFile(displayPictureLink);
        }

        if (citizenshipPhotoLink != null) {
          _peopleUpdate!.setCitizenshipPhoto =
              await imageURLToXFile(citizenshipPhotoLink);
        }
      }
      notifyListeners();
    } catch (error) {
      _peopleUpdate = null;
    }
  }

  Future<void> refreshPeopleUpdate() async {
    await retrieveUpdatePeople();
  }

  Future<bool> updatePeople() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        return true;
      }
      final request = http.MultipartRequest(
          'PUT', Uri.parse('${getHostName()}$peopleUpdateEndpoint'));

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
      };

      request.fields.addAll({
        'email': _peopleUpdate!.getEmail!,
        'full_name': _peopleUpdate!.getFullName!,
        'date_of_birth':
            Jiffy(_peopleUpdate!.getBirthDate!).format('yyyy-MM-dd'),
        'gender': _peopleUpdate!.getGender!,
        'phone': _peopleUpdate!.getPhone!,
        'address': _peopleUpdate!.getAddress!,
      });
      if (_peopleUpdate!.getDisplayPicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "display_picture", _peopleUpdate!.getDisplayPicture!.path));
      }

      if (_peopleUpdate!.getCitizenshipPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "citizenship_photo", _peopleUpdate!.getCitizenshipPhoto!.path));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(timeOutDuration);
      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  //Can be used for fetching multiple people data in parallel
  static Future<PeopleModel?> fetchPeople({
    int? peopleID,
    required AuthModel auth,
  }) async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
      return randPeople();
    }
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
      return PeopleModel.fromAPIResponse(responseData);
    } catch (error) {
      return null;
    }
  }
}
