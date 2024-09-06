import 'package:http/http.dart' as http;
import 'dart:convert';

class GetUser {
  static String baseUrl = "https://dobu.kro.kr/users";

  static Future<Map<String, dynamic>> readUser(String? token) async {
    const extraUrl = '/get/me';
    final url = Uri.parse(baseUrl + extraUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가합니다.
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      return json.decode(decodedResponse);
    } else {
      throw Exception('get user failed');
    }
  }
}
