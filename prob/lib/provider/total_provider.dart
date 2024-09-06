import 'package:flutter/material.dart';
import 'package:prob/model/total_model.dart';

class TotalProvider with ChangeNotifier {
  TotalModel? _total;
  int? _preiodTotal = -1;

  TotalModel? get total => _total;
  int? get preiodTotal => _preiodTotal;

  void setTotal(TotalModel total) {
    _total = total;
    notifyListeners();
  }

  void setPreiodTotal(int preiodTotal) {
    _preiodTotal = preiodTotal;
    notifyListeners();
  }
}
