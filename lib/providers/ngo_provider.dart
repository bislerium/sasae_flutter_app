import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class NGOProvider with ChangeNotifier {
  late AuthProvider _authP;
  List<NGO_>? _ngos; // Actual Untouched DataList
  List<NGO_>? _ngosToShow; // Filtered/search data
  final Set<String> _fieldOfWork;
  bool _isFiltered;
  bool _isSearched;
  bool _isNGOsLoading;
  //Can be used to know if fetching was unsucessful or the fetched data is empty

  NGOProvider()
      : _fieldOfWork = {},
        _isFiltered = false,
        _isSearched = false,
        _isNGOsLoading = false;

  set setAuthP(AuthProvider auth) => _authP = auth;

  List<NGO_>? get ngosData => _ngosToShow;
  Set<String> get fieldOfWork => _fieldOfWork;
  bool get fetchError => _ngos == null;
  bool get isFiltered => _isFiltered;
  bool get isSearched => _isSearched;
  bool get isNGOsLoading => _isNGOsLoading;

  void _randNGOs() {
    int length = Random().nextInt(100 - 20) + 20;
    _ngosToShow = _ngos = List.generate(
      length,
      (index) {
        return NGO_(
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

  Future<void> fetchNGOs({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) {
      _randNGOs();
    } else {
      try {
        final response = await http.get(
          Uri.parse('${getHostName()}$ngosEndpoint'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${_authP.auth!.tokenKey}'
          },
        );
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(responseData.toString());
        }
        _ngos = _ngosToShow =
            (responseData as List).map((e) => NGO_.fromAPIResponse(e)).toList();
      } catch (error) {
        _ngos = _ngosToShow = null;
      }
    }
    if (_ngos != null && _ngos!.isNotEmpty) await _extractFoW();
    _isFiltered = false;
  }

  void setRefreshingStatus(bool value) {
    _isNGOsLoading = value;
    notifyListeners();
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

  Future<void> applyFieldOfWorkFilter(List<String> filters) async {
    await Future(
      () => _ngosToShow = _ngos!.where((element) {
        return element.fieldOfWork.any((e) => filters.contains(e));
      }).toList(),
    );
    _isFiltered = true;
    notifyListeners();
  }

  void clear() {
    _ngosToShow = _ngos;
    _isFiltered = false;
    _isSearched = false;
    notifyListeners();
  }

  //----------------------------- NGO -----------------------------------------
  NGO? _ngo;

  NGO? get ngoData => _ngo;

  NGO randNGO() {
    var _isVerified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    return NGO(
      id: faker.randomGenerator.integer(1000),
      latitude: faker.randomGenerator.decimal(scale: (90 - (-90)), min: -90),
      longitude:
          faker.randomGenerator.decimal(scale: (180 - (-180)), min: -180),
      isVerified: _isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      username: faker.person.firstName(),
      orgName: ngoName,
      fieldOfWork: List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      estDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.city(),
      phone: getRandPhoneNumber(),
      email: faker.internet.email(),
      postedPosts: Set<int>.of(List.generate(faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      epayAccount: _isVerified ? getRandPhoneNumber() : null,
      bank: _isVerified
          ? Bank(
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
      panCertificateURL: _isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      swcCertificateURL: _isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Future<void> initFetchNGO({int? ngoID}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _ngo = await fetchNGO(ngoID: ngoID);
    notifyListeners();
  }

  Future<void> refreshNGO({int? ngoID}) async {
    await initFetchNGO(ngoID: ngoID);
  }

  void nullifyNGO() => _ngo = null;

  Future<NGO?> fetchNGO({int? ngoID, bool isDemo = false}) async {
    if (isDemo) {
      return randNGO();
    } else {
      try {
        final response = await http.get(
          Uri.parse(
              '${getHostName()}$ngoEndpoint${ngoID ?? _authP.auth!.profileID}/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token ${_authP.auth!.tokenKey}'
          },
        );
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(responseData.toString());
        }
        return NGO.fromAPIResponse(responseData);
      } catch (error) {
        return null;
      }
    }
  }
}
