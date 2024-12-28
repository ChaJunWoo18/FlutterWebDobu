import 'package:flutter/material.dart';
import 'package:prob/api/saving.dart';
import 'package:prob/model/saving_model.dart';
import 'package:intl/intl.dart';

class SavingProvider with ChangeNotifier {
  bool isLoading = true;
  String? errorMessage;
  List<GroupedSavings> savingsData = [];

  void setSavings(List<GroupedSavings> data) {
    savingsData = data;
    notifyListeners();
  }

  Future<void> fetchSavingsData(String? token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // await Future.delayed(const Duration(seconds: 1));
      savingsData = await SavingApi.getSaving(token);
      isLoading = false;
    } catch (error) {
      // print(error);
      errorMessage = "요청 실패. 다시 시도하세요";
      isLoading = false;
    }
    notifyListeners();
  }

  void setEditInfo({
    required date,
    required receiver,
    required amount,
  }) {
    dateController.text = date.toIso8601String().substring(0, 10);
    receiverController.text = receiver;
    amountController.text = formatNumberWithComma(amount);
  }

  String formatNumberWithComma(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  //소비처, 소비금액,
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void disposeControllers() {
    receiverController.dispose();
    amountController.dispose();
    dateController.dispose();
    notifyListeners();
  }

  String? _receiverError;
  String? _amountError;
  String? _dateError;

  String? get receiverError => _receiverError;
  String? get amountError => _amountError;
  String? get dateError => _dateError;

  bool isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(date);
  }

  // 유효성 검사
  bool validateFields({required bool isRepeat}) {
    bool isValid = true;
    if (dateController.text.isEmpty) {
      _dateError = '날짜를 선택하세요';
      isValid = false;
    } else if (isValidDateFormat(dateController.text)) {
      _dateError = '잘못된 날짜 형식입니다';
      isValid = false;
    } else {
      _dateError = null;
    }
    if (receiverController.text.isEmpty) {
      _receiverError = '소비처를 입력해주세요';
      isValid = false;
    } else if (receiverController.text.length > 8) {
      _receiverError = '8자 이내로 입력해주세요';
      isValid = false;
    } else {
      _receiverError = null;
    }
    String amountText = amountController.text.replaceAll(',', '');
    if (amountController.text.isEmpty) {
      _amountError = '금액을 입력해주세요';
      isValid = false;
    } else if (int.tryParse(amountText) == null) {
      _amountError = '숫자를 입력해주세요';
      isValid = false;
    } else if (amountText.length > 11) {
      _amountError = '너무 큰 숫자에요';
      isValid = false;
    } else {
      _amountError = null;
    }
    notifyListeners();
    return isValid;
  }

  void resetFields() {
    dateController.clear();
    receiverController.clear();
    amountController.clear();
    _receiverError = null;
    _amountError = null;
    notifyListeners();
  }

  void clear() {
    isLoading = true;
    errorMessage = null;
    savingsData = [];
    _receiverError = null;
    _amountError = null;
    _dateError = null;
    receiverController.clear();
    amountController.clear();
    dateController.clear();
  }

  SavingModel getFieldValues() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return SavingModel(
        id: -1,
        date: dateFormat.parse(dateController.text),
        receiver: receiverController.text,
        amount: int.parse(amountController.text));
  }
}
