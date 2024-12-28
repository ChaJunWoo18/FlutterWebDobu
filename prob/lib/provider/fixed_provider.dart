import 'package:flutter/material.dart';
import 'package:prob/api/fixed_consume.dart';
import 'package:prob/model/fixed_model.dart';

class FixedProvider extends ChangeNotifier {
  List<FixedModel> _fixedList = [];

  List<FixedModel> get fixedList => _fixedList;

  void setFixedList(List<FixedModel> list) {
    _fixedList = list;
    notifyListeners();
  }

  void addFixedConsume(FixedModel el) {
    _fixedList.add(el);
    notifyListeners();
  }

  void removeFixedConsume(int id) {
    _fixedList.removeWhere((fixed) => fixed.id == id);
    notifyListeners();
  }

  Future<void> fetchFixedConsume(String? token) async {
    final res = await FixedConsumeApi.getFixed(token);
    setFixedList(res);
  }

  void clear() {
    _fixedList.clear();
  }
}
