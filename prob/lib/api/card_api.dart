import 'package:http/http.dart' as http;
import 'package:prob/api/api_url.dart';
import 'package:prob/model/card_model.dart';
import 'dart:convert';

class CardApi {
  //유저 카테고리 조회
  static Future<List<CardModel>> readCards(String? token) async {
    const extraUrl = '/cards/get/card.list';
    final url = Uri.parse(ApiConstants.baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => CardModel.fromJson(data)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('카드 목록 조회 실패');
    }
  }
}
