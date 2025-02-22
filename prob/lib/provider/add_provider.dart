import 'package:flutter/material.dart';

enum RepeatOption { none, installment, repeat }

class AddProvider with ChangeNotifier {
  String _installmentSelected = 'none';
  bool _installmentIsSelfInput = false;
  String _installmentSelfInputValue = '';

  String _categorySelected = 'none';

  String _cardSelected = 'none';

  // 첫 번째 드롭다운 메뉴 getter
  String get installmentSelected => _installmentSelected;
  bool get installmentIsSelfInput => _installmentIsSelfInput;
  String get installmentSelfInputValue => _installmentSelfInputValue;

  String get categorySelected => _categorySelected;

  String get cardSelected => _cardSelected;

  void setInstallmentSelected(String value) {
    _installmentSelected = value;
    _installmentIsSelfInput = value == 'self';
    notifyListeners();
  }

  void setInstallmentSelfInputValue(String value) {
    _installmentSelfInputValue = value;
    notifyListeners();
  }

  void setSecondSelectedOption(String value) {
    _categorySelected = value;
    notifyListeners();
  }

  void setThirdSelectedOption(String value) {
    _cardSelected = value;
    notifyListeners();
  }

  void setEditInfo(
      {required receiver,
      required amount,
      installment,
      required categoryName,
      String? cardName}) {
    _installmentSelected = 'self';
    _installmentIsSelfInput = true;
    contentController.text = receiver;
    amountController.text = amount;
    installmentController.text = installment;
    _categorySelected = categoryName;
    _cardSelected = cardName ?? 'none';
  }

  void setFixedInfo(
      {required date,
      required receiver,
      required amount,
      required categoryName,
      String? cardName}) {
    contentController.text = receiver;
    amountController.text = amount;
    dateController.text = date;
    _categorySelected = categoryName;
    _cardSelected = cardName ?? 'none';
  }

  //소비처, 소비금액,
  final TextEditingController contentController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController installmentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void disposeControllers() {
    contentController.dispose();
    amountController.dispose();
    installmentController.dispose();
    dateController.dispose();
    notifyListeners();
  }

  String? _companyError;
  String? _amountError;
  String? _installmentError;
  String? _categoryError;
  String? _dateError;

  String? get companyError => _companyError;
  String? get amountError => _amountError;
  String? get installmentError => _installmentError;
  String? get categoryError => _categoryError;
  String? get dateError => _dateError;

  bool isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(date);
  }

  // 유효성 검사
  bool validateFields({required bool isRepeat}) {
    bool isValid = true;

    if (isRepeat) {
      if (dateController.text.isEmpty) {
        _dateError = '날짜를 선택하세요';
        isValid = false;
      } else if (isValidDateFormat(dateController.text)) {
        _dateError = '잘못된 날짜 형식입니다';
        isValid = false;
      } else {
        _dateError = null;
      }
    }

    if (contentController.text.isEmpty) {
      _companyError = '소비처를 입력해주세요';
      isValid = false;
    } else if (contentController.text.length > 8) {
      _companyError = '8자 이내로 입력해주세요';
      isValid = false;
    } else {
      _companyError = null;
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
    if (_installmentIsSelfInput) {
      if (installmentController.text.isEmpty) {
        _installmentError = '개월 수를 입력해주세요';
        isValid = false;
      } else if (int.tryParse(installmentController.text) == null) {
        _installmentError = '할부는 숫자만 입력해주세요';
        isValid = false;
      } else if ((int.tryParse(installmentController.text))! > 60) {
        _installmentError = '60이하만 가능해요';
        isValid = false;
      } else {
        _installmentError = null;
      }
    }

    if (_categorySelected == 'none' || _categorySelected == '') {
      _categoryError = '카테고리를 선택해주세요';
      isValid = false;
    } else {
      _categoryError = null;
    }

    notifyListeners();
    return isValid;
  }

  void resetFields() {
    // 드롭다운 메뉴 상태 초기화
    _installmentSelected = 'none';
    _installmentIsSelfInput = false;
    _installmentSelfInputValue = '';
    _categorySelected = 'none';
    _cardSelected = 'none';

    // 텍스트 필드 컨트롤러 초기화
    contentController.clear();
    amountController.clear();
    installmentController.clear();
    dateController.clear();
    // 오류 메시지 초기화
    _companyError = null;
    _amountError = null;
    _installmentError = null;
    _categoryError = null;
    _dateError = null;
    notifyListeners();
  }

  Map<String, dynamic> getFieldValues() {
    return {
      'installment': _installmentIsSelfInput == true
          ? installmentController.text
          : _installmentSelected,
      'category': _categorySelected,
      'card': _cardSelected,
      'content': contentController.text,
      'amount': amountController.text,
      'date': dateController.text,
    };
  }
}
