import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _page = 1;
  set pageIndex(value) {
    _page = value;
  }

  get pageIndex => _page;
  goToNextPage(ScrollController myScrollController) {
    _page++;
myScrollController.animateTo(0.0,
                                duration: const Duration(milliseconds: 1200),
                                curve: Curves.easeInOut);
    notifyListeners();
  }

  goToPreviousPage(ScrollController myScrollController) {
    if (_page > 1) {
      _page--;
      myScrollController.animateTo(0.0,
                                duration: const Duration(milliseconds: 1200),
                                curve: Curves.easeInOut);
    }

    notifyListeners();
  }
}
