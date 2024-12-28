import 'package:flutter/material.dart';

class TotalProvider with ChangeNotifier {
  int? _monthTotal;
  int? _weekTotal;

  int? get monthTotal => _monthTotal;
  int? get weekTotal => _weekTotal;

  void setMonthTotal(int monthTotal) {
    _monthTotal = monthTotal;
    notifyListeners();
  }

  void setWeekTotal(int weekTotal) {
    _weekTotal = weekTotal;
    notifyListeners();
  }

  void editTotal({required bool isPlus, required int value}) {
    if (isPlus) {
      _monthTotal = value + _monthTotal!;
      _weekTotal = value + _weekTotal!;
    } else {
      _monthTotal = _monthTotal! - value;
      _weekTotal = _weekTotal! - value;
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void clear() {
    _monthTotal = null;
    _weekTotal = null;
  }
}
