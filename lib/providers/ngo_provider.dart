import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class NGOProvider with ChangeNotifier {
  late AuthProvider _authP;
  List<NGO_Model>? _ngos; // Actual Untouched DataList
  List<NGO_Model>? _ngosToShow; // Filtered/search data
  final Set<String> _fieldOfWork;
  List<String> _selectedFOW;
  bool _isFiltered;
  bool _isSearched;
  //Can be used to know if fetching was unsucessful or the fetched data is empty

  NGOProvider()
      : _fieldOfWork = {},
        _isFiltered = false,
        _isSearched = false,
        _selectedFOW = [];

  set setAuthP(AuthProvider auth) => _authP = auth;

  set setSelectedFOW(List<String> selectedFOW) => _selectedFOW = selectedFOW;

  List<NGO_Model>? get getNGOs => _ngosToShow;
  Set<String> get getFieldOfWork => _fieldOfWork;
  List<String> get getSelectedFOW => _selectedFOW;
  bool get getIsFetchError => _ngos == null;
  bool get getIsFiltered => _isFiltered;
  bool get getIsSearched => _isSearched;

  void _randNGOs() {
    int length = Random().nextInt(40 - 20) + 20;
    _ngosToShow = _ngos = List.generate(
      length,
      (index) {
        return NGO_Model(
          ngoID: index,
          orgName: faker.company.name(),
          orgPhoto: faker.image.image(random: true),
          estDate: faker.date.dateTime(minYear: 2000, maxYear: 2022),
          address: faker.address.city() + faker.address.streetAddress(),
          fieldOfWork: List.generate(
            Random().nextInt(8 - 1) + 1,
            (index) => faker.lorem.word(),
          ),
        );
      },
    );
  }

  Future<void> fetchNGOs() async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
      _randNGOs();
    } else {
      try {
        final response = await http.get(
          Uri.parse('${getHostName()}$ngosEndpoint'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${_authP.getAuth!.tokenKey}'
          },
        ).timeout(timeOutDuration);
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(responseData.toString());
        }
        _ngos = _ngosToShow = (responseData as List)
            .map((e) => NGO_Model.fromAPIResponse(e))
            .toList();
      } catch (error) {
        _ngos = _ngosToShow = null;
      }
    }
    if (_ngos != null && _ngos!.isNotEmpty) await _extractFoW();
    _isFiltered = false;
  }

  Future<void> refreshNGOs() async {
    await fetchNGOs();
    _isFiltered = false;
    notifyListeners();
  }

  Future<void> _extractFoW() async {
    await Future(() {
      if (_fieldOfWork.isNotEmpty) _fieldOfWork.clear();
      for (var ngo in _ngos!) {
        for (var field in ngo.fieldOfWork) {
          _fieldOfWork.add(field);
        }
      }
    });
  }

  Future<void> searchByName(String name) async {
    if (name.isEmpty) {
      _ngosToShow = _ngos;
      _isSearched = false;
    } else {
      await Future(
        () => _ngosToShow = _ngos!
            .where(
                (ngo) => ngo.orgName.toLowerCase().contains(name.toLowerCase()))
            .toList(),
      );
      _isSearched = true;
    }
    notifyListeners();
  }

  Future<void> applyFieldOfWorkFilter() async {
    await Future(
      () => _ngosToShow = _ngos!.where((element) {
        return element.fieldOfWork.any((e) => _selectedFOW.contains(e));
      }).toList(),
    );
    _isFiltered = true;
    notifyListeners();
  }

  void clear() {
    _ngosToShow = _ngos;
    _isFiltered = false;
    _isSearched = false;
    _selectedFOW = [];
    notifyListeners();
  }

  void disposeNGOs() {
    _ngosToShow = _ngos = null;
    _isFiltered = false;
    _isSearched = false;
    _selectedFOW = [];
    _fieldOfWork.clear();
  }

  //----------------------------- NGO -----------------------------------------
  NGOModel? _ngo;

  NGOModel? get getNGO => _ngo;

  static NGOModel randNGO() {
    var isVerified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    return NGOModel(
      id: faker.randomGenerator.integer(1000),
      latitude: faker.randomGenerator.decimal(scale: (27 - (22)), min: 22),
      longitude: faker.randomGenerator.decimal(scale: (90 - (75)), min: 75),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      username: faker.person.firstName(),
      orgName: ngoName,
      fieldOfWork: List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      estDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.city() + faker.address.streetAddress(),
      phone: getRandPhoneNumber(),
      email: faker.internet.email(),
      postedPosts: Set<int>.of(List.generate(faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      epayAccount: isVerified ? getRandPhoneNumber() : null,
      bank: isVerified
          ? BankModel(
              bankName: faker.company.name(),
              bankBranch: faker.address.city(),
              bankBSB:
                  int.parse(faker.randomGenerator.numberOfLength(6)).toString(),
              bankAccountName: ngoName,
              bankAccountNumber: int.parse(faker.randomGenerator.numberOfLength(
                      faker.randomGenerator.integer(16, min: 9)))
                  .toString(),
            )
          : null,
      panCertificateURL: isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      swcCertificateURL: isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Future<void> initFetchNGO({int? ngoID}) async {
    _ngo = await fetchNGO(ngoID: ngoID, auth: _authP.getAuth!);
  }

  Future<void> refreshNGO({int? ngoID}) async {
    await initFetchNGO(ngoID: ngoID);
    notifyListeners();
  }

  void nullifyNGO() => _ngo = null;

  static Future<NGOModel?> fetchNGO(
      {int? ngoID, required AuthModel auth}) async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
      return randNGO();
    } else {
      try {
        final response = await http.get(
          Uri.parse('${getHostName()}$ngoEndpoint${ngoID ?? auth.profileID}/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${auth.tokenKey}'
          },
        ).timeout(timeOutDuration);
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(responseData.toString());
        }
        return NGOModel.fromAPIResponse(responseData);
      } catch (error) {
        return null;
      }
    }
  }
}
