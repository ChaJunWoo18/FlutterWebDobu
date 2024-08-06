import 'package:http/http.dart' as http;
import 'package:prob/model/hist_model.dart';
import 'dart:convert';
import 'package:prob/model/reqModel/add_consume_hist.dart';

class ConsumeHistApi {
  static String baseUrl = "http://127.0.0.1:8000/consume.history";

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
  static Future<List<HistModel>> getHist(String? token) async {
    const extraUrl = '/';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> consumeHistList = json.decode(response.body);
      print(consumeHistList);
      List<HistModel> histModels =
          consumeHistList.map((hist) => HistModel.fromJson(hist)).toList();
      print(histModels);
      return histModels;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}
