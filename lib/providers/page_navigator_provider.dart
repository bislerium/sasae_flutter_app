import 'package:flutter/material.dart';

class PageNavigatorProvider extends ChangeNotifier {
  int _pageIndex;
  final PageController _pageController;

  PageNavigatorProvider()
      : _pageIndex = 2,
        _pageController = PageController(initialPage: 2);

  int get getPageIndex => _pageIndex;

  PageController get getPageController => _pageController;

  set setPageIndex(int index) {
    if (_pageIndex != index) {
      _pageIndex = index;
      notifyListeners();
    }
  }

  void navigateToPage() {
    _pageController.animateToPage(
      _pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
