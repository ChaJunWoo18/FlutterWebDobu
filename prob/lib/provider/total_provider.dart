import 'package:flutter/material.dart';
import 'package:prob/model/total_model.dart';

class TotalProvider with ChangeNotifier {
  TotalModel? _total;

  TotalModel? get total => _total;

  void setTotal(TotalModel total) {
    _total = total;
    notifyListeners();
  }
}
