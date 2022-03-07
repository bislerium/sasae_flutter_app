import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';

class NGOProvider with ChangeNotifier {
  List<NGO_> _ngoDataList; // Actual Untouched DataList
  List<NGO_> _dataToShow; // Filtered/search data
  final Set<String> _fieldOfWork;
  bool _isFiltered;
  bool _isSearched;
  bool _isRefreshing;
  //Can be used to know if fetching was unsucessful or the fetched data is empty

  NGOProvider()
      : _ngoDataList = [],
        _dataToShow = [],
        _fieldOfWork = {},
        _isFiltered = false,
        _isSearched = false,
        _isRefreshing = false;

  List<NGO_> get ngoData => _dataToShow;
  Set<String> get fieldOfWork => _fieldOfWork;
  bool get isFiltered => _isFiltered;
  bool get isSearched => _isSearched;
  bool get isRefreshing => _isRefreshing;

  void _randNGOs() {
    int length = Random().nextInt(100 - 20) + 20;
    _dataToShow = _ngoDataList = List.generate(
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
    await Future.delayed(const Duration(seconds: 2));
    if (isDemo) _randNGOs();
    if (_dataToShow.isNotEmpty) await _extractFoW();
    _isFiltered = false;
  }

  void setRefreshingStatus(bool value) {
    _isRefreshing = value;
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
      for (var ngo in _ngoDataList) {
        for (var field in ngo.fieldOfWork) {
          _fieldOfWork.add(field);
        }
      }
    });
  }

  Future<void> searchByName(String name) async {
    if (name.isEmpty) {
      _dataToShow = _ngoDataList;
      _isSearched = false;
    } else {
      await Future(
        () => _dataToShow = _ngoDataList
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
      () => _dataToShow = _ngoDataList.where((element) {
        return element.fieldOfWork.any((e) => filters.contains(e));
      }).toList(),
    );
    _isFiltered = true;
    notifyListeners();
  }

  void clear() {
    _dataToShow = _ngoDataList;
    _isFiltered = false;
    _isSearched = false;
    notifyListeners();
  }
}
