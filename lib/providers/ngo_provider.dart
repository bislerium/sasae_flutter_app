import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class NGOProvider with ChangeNotifier {
  List<NGO_> _ngos; // Actual Untouched DataList
  List<NGO_> _ngosToShow; // Filtered/search data
  final Set<String> _fieldOfWork;
  bool _isFiltered;
  bool _isSearched;
  bool _isNGOsLoading;
  //Can be used to know if fetching was unsucessful or the fetched data is empty

  NGOProvider()
      : _ngos = [],
        _ngosToShow = [],
        _fieldOfWork = {},
        _isFiltered = false,
        _isSearched = false,
        _isNGOsLoading = false;

  List<NGO_> get ngoData => _ngosToShow;
  Set<String> get fieldOfWork => _fieldOfWork;
  bool get isFiltered => _isFiltered;
  bool get isSearched => _isSearched;
  bool get isNGOsLoading => _isNGOsLoading;

  void _randNGOs() {
    int length = Random().nextInt(100 - 20) + 20;
    _ngosToShow = _ngos = List.generate(
      length,
      (index) {
        return NGO_(
          id: index,
          ngoURL: faker.internet.httpsUrl(),
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

  Future<void> fetchNGOs({bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) _randNGOs();
    if (_ngosToShow.isNotEmpty) await _extractFoW();
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
      for (var ngo in _ngos) {
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
        () => _ngosToShow = _ngos
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
      () => _ngosToShow = _ngos.where((element) {
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

  NGO? get ngo => _ngo;

  void _randNGO() {
    var _isVerified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    _ngo = NGO(
      id: faker.randomGenerator.integer(1000),
      latitude: faker.randomGenerator.decimal(scale: (90 - (-90)), min: -90),
      longitude:
          faker.randomGenerator.decimal(scale: (180 - (-180)), min: -180),
      isVerified: _isVerified,
      orgPhoto: faker.image.image(width: 600, height: 600, random: true),
      orgName: ngoName,
      fieldOfWork: List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      estDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.city(),
      phone: getRandPhoneNumber(),
      email: faker.internet.email(),
      epayAccount: _isVerified ? getRandPhoneNumber() : null,
      bank: _isVerified
          ? Bank(
              bankName: faker.company.name(),
              bankBranch: faker.address.city(),
              bankBSB: int.parse(faker.randomGenerator.numberOfLength(6)),
              bankAccountName: ngoName,
              bankAccountNumber: int.parse(faker.randomGenerator
                  .numberOfLength(faker.randomGenerator.integer(16, min: 9))),
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

  Future<void> fetchNGO({required int ngoID, bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) _randNGO();
  }

  void nullifyNGO() => _ngo = null;

  Future<void> refreshNGO(int ngoID) async {
    await fetchNGO(ngoID: ngoID);
    notifyListeners();
  }
}
