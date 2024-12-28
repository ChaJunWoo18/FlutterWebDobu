import 'package:http/http.dart' as http;
import 'package:prob/model/fixed_model.dart';
import 'dart:convert';

import 'package:prob/model/reqModel/add_consume_hist.dart';

class FixedConsumeApi {
  static String baseUrl = "http://localhost:8000/fixed";

  //고정지출 조회
  static Future<List<FixedModel>> getFixed(String? token) async {
    final url = Uri.parse('$baseUrl/read/fixed-consume');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> fixedHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(fixedHistList);
      return fixedHistList.map((hist) => FixedModel.fromJson(hist)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  //고정 지출 삭제
  static Future<bool> removeFixed(int histId, String? token) async {
    final url = Uri.parse('$baseUrl/del/fixed-consume/$histId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  //고정지출 추가
  static Future<List<FixedModel>> addFixed(
      AddConsumeHist addConsumeHist, String? token) async {
    const extraUrl = '/fixed-consume';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "receiver": addConsumeHist.content,
          "date": addConsumeHist.date,
          "amount": int.parse(addConsumeHist.amount),
          "repeat": addConsumeHist.repeat,
          "card": addConsumeHist.card,
          "category_name": addConsumeHist.categoryName
        }));

    if (response.statusCode == 200) {
      final List<dynamic> fixedHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(consumeHistList);
      List<FixedModel> histModels =
          fixedHistList.map((data) => FixedModel.fromJson(data)).toList();
      return histModels;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }
}
