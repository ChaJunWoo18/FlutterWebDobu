import 'package:http/http.dart' as http;
import 'package:prob/model/hist_model.dart';
import 'dart:convert';
import 'package:prob/model/reqModel/add_consume_hist.dart';

class ConsumeHistApi {
  static String baseUrl = "https://dobu.kro.kr/consume.history";

  static Future<dynamic> addHist(
      AddConsumeHist addConsumeHist, String? token) async {
    const extraUrl = '/add/new_history';
    final url = Uri.parse(
        '$baseUrl$extraUrl?category_name=${addConsumeHist.categoryName}');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "receiver": addConsumeHist.receiver,
          "date": addConsumeHist.date,
          "amount": addConsumeHist.amount,
        }));

    if (response.statusCode == 200) {
      //print(response.body);
      return response.body;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }

  //조회
  static Future<List<HistModel>> getHist(
      String? token, String startDate, String endDate) async {
    final url = Uri.parse('$baseUrl?startDate=$startDate&endDate=$endDate');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> consumeHistList =
          json.decode(utf8.decode(response.bodyBytes));

      List<HistModel> histModels =
          consumeHistList.map((hist) => HistModel.fromJson(hist)).toList();

      return histModels;
    } else if (response.statusCode == 400) {
      return [];
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  //delete
  static Future<dynamic> removeHistOne(int histId, String? token) async {
    final url = Uri.parse('$baseUrl/$histId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return response.body;
    } else {
      throw Exception("can't remove history. please retry");
    }
  }
}
