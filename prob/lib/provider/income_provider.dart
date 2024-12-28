import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/api/income_api.dart';
import 'package:prob/model/income_model.dart';

class IncomeProvider with ChangeNotifier {
  IncomeModel? _incomeData;
  bool isLoading = true;
  bool _canEdit = false;
  String? _errorText;
  int? _nextIncome;

  bool get canEdit => _canEdit;
  IncomeModel? get incomeData => _incomeData;
  int? get nextIncome => _nextIncome;
  String? get errorText => _errorText;

  void setIncome(IncomeModel incomeData) {
    _incomeData = incomeData;
    notifyListeners();
  }

  void setNextIncome(int nextIncome) {
    _nextIncome = nextIncome;
    notifyListeners();
  }

  Future<void> fetchIncomeData(String? token) async {
    isLoading = true;
    _errorText = null;
    notifyListeners();

    try {
      // await Future.delayed(const Duration(seconds: 1));
      _incomeData = await IncomeApi.getIncome(token);
      isLoading = false;
    } catch (error) {
      _errorText = "요청 실패. 다시 시도하세요";
      isLoading = false;
    }
    notifyListeners();
  }

  String formatNumberWithComma(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  void setErrorText(String? text) {
    _errorText = text;
    notifyListeners();
  }

  void toggleCanEdit() {
    _canEdit = !_canEdit;
    notifyListeners();
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
    _errorText = null;
  }

  void clear() {
    _incomeData = null;
    isLoading = true;
    _canEdit = false;
    _errorText = null;
    _nextIncome = null;
  }
}
