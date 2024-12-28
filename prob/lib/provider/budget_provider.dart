import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/model/budget_model.dart';
import 'package:prob/service/this_week_cal.dart';

class BudgetProvider with ChangeNotifier {
  BudgetModel? _budgetData;
  RemainBudget? _remainBudget;
  int? _nextBudget;
  bool _canEdit = false;
  String? _errorText;

  BudgetModel? get budgetData => _budgetData;
  RemainBudget? get remainBudget => _remainBudget;
  int? get nextBudget => _nextBudget;
  bool get canEdit => _canEdit;
  String? get errorText => _errorText;

  void setBudget(BudgetModel budgetModel) {
    _budgetData = budgetModel;
    notifyListeners();
  }

  void setBudgetAmount(int budgetAmount) {
    _budgetData!.curBudget = budgetAmount;
    notifyListeners();
  }

  void setNextBudget(int nextBudget) {
    _nextBudget = nextBudget;
    notifyListeners();
  }

  void setRemainBudget({
    required int curBudget,
    required int weekTotal,
    required int monthTotal,
  }) {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
    int remainingDays = ThisWeekCal.countRemainingDaysInCurrentWeek(now);

    _remainBudget = RemainBudget(
      week: (curBudget ~/ remainingDays - weekTotal),
      month: (curBudget - monthTotal),
    );
    notifyListeners();
  }

  void updateRemainBudget({required int newBudget}) {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
    int remainingDays = ThisWeekCal.countRemainingDaysInCurrentWeek(now);
    final oldBudget = _remainBudget;
    _remainBudget = RemainBudget(
      week: (newBudget ~/ remainingDays - oldBudget!.week),
      month: (newBudget - oldBudget.month),
    );
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void toggleCanEdit() {
    _canEdit = !_canEdit;
    notifyListeners();
  }

  void setErrorText(String? text) {
    _errorText = text;
    notifyListeners();
  }

  String formatNumberWithComma(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  final TextEditingController controller = TextEditingController();
  void disposeControllers() {
    controller.dispose();
    notifyListeners();
  }

  bool validNextValue() {
    int? a = int.tryParse(controller.text);
    if (controller.text.isEmpty || a == null || controller.text == '') {
      setErrorText('숫자를 입력하세요');
      return false;
    }
    setErrorText(null);
    return true;
  }

  void reset() {
    controller.text = '';
    _nextBudget = null;
  }

  void clear() {
    _budgetData = null;
    _remainBudget = null;
    _nextBudget = null;
    _canEdit = false;
    _errorText = null;
  }
}

class RemainBudget {
  final int week;
  final int month;

  RemainBudget({
    required this.week,
    required this.month,
  });
}
