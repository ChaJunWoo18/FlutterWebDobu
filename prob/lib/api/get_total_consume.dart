import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/total_model.dart';

class GetTotalConsume {
  static String baseUrl = "https://dobu.kro.kr/total";

  static Future<TotalModel> readTotalConsume(String? token) async {
    const extraUrl = '/get/total/consume';
    final url = Uri.parse(baseUrl + extraUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가합니다.
      },
    );

    if (response.statusCode == 200) {
      return TotalModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'get user or get total_consume failed. Token may have expired');
    }
  }

  //기간 소비 조회
  static Future<int> readPreiodTotal(
      String startDate, String endDate, String? token) async {
    final extraUrl =
        '/get/total/consume/period?startDate=$startDate&endDate=$endDate';
    final url = Uri.parse(baseUrl + extraUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가합니다.
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception(
          'get user or get total_consume failed. Token may have expired');
    }
  }
}
