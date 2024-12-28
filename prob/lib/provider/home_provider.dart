import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _homeWidget = 'mainPage';

  String get homeWidget => _homeWidget;

  void setHomeWidget(String seletedWidget) {
    _homeWidget = seletedWidget;
    _profile = 'profile';
    notifyListeners();
  }

  String _profile = 'profile';

  String get profile => _profile;

  void setProfile(String seletedWidget) {
    _profile = seletedWidget;
    _homeWidget = 'mainPage';
    notifyListeners();
  }

  void reset() {
    _homeWidget = 'mainPage';
    _profile = 'profile';
  }
}
