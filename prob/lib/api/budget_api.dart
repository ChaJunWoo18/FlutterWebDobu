import 'package:http/http.dart' as http;
import 'package:prob/api/api_url.dart';
import 'dart:convert';

import 'package:prob/model/budget_model.dart';

class BudgetApi {
  static Future<BudgetModel> readBudget(String? token) async {
    const extraUrl = '/budgets/get/budget';
    final url = Uri.parse(ApiConstants.baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      // print('${response.statusCode}');
      throw Exception('예산 가져오기 실패');
    }
  }

  static Future<BudgetModel> updateBudget(String? token, int newBudget) async {
    const extraUrl = '/budgets/update/budget';
    final url = Uri.parse(ApiConstants.baseUrl + extraUrl);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'new_budget': newBudget}),
    );

    if (response.statusCode == 200) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 406) {
      throw Exception('값이 너무 커요');
    } else {
      throw Exception('예산 업데이트 실패');
    }
  }
}
