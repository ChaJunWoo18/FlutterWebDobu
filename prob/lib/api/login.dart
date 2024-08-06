import 'package:http/http.dart' as http;
import 'dart:convert';

class Login {
  static String baseUrl = "http://127.0.0.1:8000/token";

  static Future<Map<String, dynamic>> getToken(
      String email, String password) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('get token failed');
    }
  }
}
