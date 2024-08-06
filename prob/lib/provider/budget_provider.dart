import 'package:flutter/material.dart';
import 'package:prob/model/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  BudgetModel? _budgetData;

  BudgetModel? get budgetData => _budgetData;

  void setBudget(BudgetModel budget) {
    _budgetData = budget;
    notifyListeners();
  }
}
