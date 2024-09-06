import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _category = [];
  String? _selectedCategory;

  List<String> get category => _category;
  String? get selectedCategory => _selectedCategory;

  void setCategory(List<String> category) {
    _category = category;
    notifyListeners();
  }

  void addCategory(String categoryName) {
    _category.add(categoryName);
    notifyListeners();
  }

  void setSelectedCategory(String? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }

  void removeCategory(String? categoryName) {
    _category.remove(categoryName);
    notifyListeners();
  }
}
