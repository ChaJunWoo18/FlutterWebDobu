import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/income_model.dart';

class IncomeApi {
  static String baseUrl = "http://localhost:8000/income";

  static Future<IncomeModel> getIncome(String? token) async {
    final url = Uri.parse('$baseUrl/get/income');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final data = IncomeModel.fromJson(jsonData);
      return data;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  static Future<IncomeModel> updateIncome(String? token, int newIncome) async {
    const extraUrl = '/update/income';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'new_income': newIncome}),
    );

    if (response.statusCode == 200) {
      return IncomeModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 406) {
      throw Exception('값이 너무 커요');
    } else {
      throw Exception('예산 업데이트 실패');
    }
  }

  // static Future<bool> removeFixed(int histId, String? token) async {
  //   final url = Uri.parse('$baseUrl/del/fixed-consume/$histId');
  //   final response = await http.delete(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     throw Exception('요청 실패. 관리자에게 문의하세요.');
  //   }
  // }

  // static Future<Map<String, dynamic>> addSaving(
  //     SavingModel savingModel, String? token) async {
  //   const extraUrl = '/add/data';
  //   final url = Uri.parse('$baseUrl$extraUrl');
  //   final response = await http.post(url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(savingModel.toJson()));
  //   // jsonEncode({
  //   //   "date": savingModel.date,
  //   //   "receiver": savingModel.receiver,
  //   //   "amount": int.parse(savingModel.amount),
  //   // }));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonData =
  //         json.decode(utf8.decode(response.bodyBytes));
  //     return jsonData;
  //   } else {
  //     throw Exception('요청 실패. 관리자에게 문의하세요.');
  //   }
  // }
}
