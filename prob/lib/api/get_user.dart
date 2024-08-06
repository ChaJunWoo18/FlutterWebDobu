import 'package:http/http.dart' as http;
import 'dart:convert';

class GetUser {
  static String baseUrl = "http://127.0.0.1:8000/users";

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
      //print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}
