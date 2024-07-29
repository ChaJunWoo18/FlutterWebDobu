import 'package:flutter/material.dart';

class LookListProvider extends ChangeNotifier {
  bool _LookList = false;

  bool get showListView => _LookList;

  void toggleView() {
    _LookList = !_LookList;
    notifyListeners();
  }
}
