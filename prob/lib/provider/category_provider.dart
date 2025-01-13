import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prob/api/category_api.dart';
import 'package:prob/model/categories_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoriesModel> _userCategory = [];
  List<CategoriesModel> get userCategory => _userCategory;
  final List<int> _changedCategories = [];
  Timer? _debounceTimer;

  void setCategory(List<CategoriesModel> categoryList) {
    _userCategory = categoryList;
    sortCategoryByVisible();
    notifyListeners();
  }

  void sortCategoryByVisible() {
    userCategory.sort((a, b) {
      // true가 앞에 오도록 정렬
      if (a.visible && !b.visible) return -1;
      if (!a.visible && b.visible) return 1;
      //visible이 같으면 id내림차순
      return a.id.compareTo(b.id);
    });
  }

  // 변경 사항 서버로 동기화
  Future<void> _sendChangesToServer(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final accessToken = await authProvider.getToken();
    if (_changedCategories.isNotEmpty) {
      try {
        await CategoryApi.syncCategory(_changedCategories, accessToken);
        _changedCategories.clear();
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  void _startDebounce(BuildContext context) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(seconds: 3),
      () => _sendChangesToServer(context),
    );
  }

  Future<void> immediateSync(BuildContext context) async {
    _debounceTimer?.cancel();
    await _sendChangesToServer(context);
  }

  void toggleVisibile(int categoryId, BuildContext context) {
    final index = userCategory.indexWhere((cat) => cat.id == categoryId);
    if (index != -1) {
      userCategory[index] = CategoriesModel(
        id: userCategory[index].id,
        subId: userCategory[index].subId,
        name: userCategory[index].name,
        icon: userCategory[index].icon,
        color: userCategory[index].color,
        chart: userCategory[index].chart,
        visible: !userCategory[index].visible,
      );
      if (!_changedCategories.contains(categoryId)) {
        _changedCategories.add(categoryId);
      }
      sortCategoryByVisible();
      notifyListeners();
      _startDebounce(context);
    }
  }

  Future<void> fetchCategories(BuildContext context) async {
    try {
      // AuthProvider에서 토큰 유효성 확인 및 재발급 처리
      final authProvider = context.read<AuthProvider>();

      final accessToken = await authProvider.getToken();
      if (accessToken == 'fail' && context.mounted) {
        MyAlert.failShow(context, '로그인 만료', '/');
      }
      final data = await CategoryApi.readCategories(accessToken);
      _userCategory = data;
      sortCategoryByVisible();
      notifyListeners(); // UI 갱신 알림
    } catch (e) {
      throw Exception(e);
    }
  }
}
