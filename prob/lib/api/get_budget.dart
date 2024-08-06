import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/budget_model.dart';

class GetBudget {
  static String baseUrl = "http://127.0.0.1:8000/budgets";

  static Future<BudgetModel> readBudget(String? token) async {
    const extraUrl = '/get/budget';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가합니다.
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}
