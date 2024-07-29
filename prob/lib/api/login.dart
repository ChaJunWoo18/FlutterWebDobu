import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/user_model.dart';

class Login {
  static String baseUrl = "http://127.0.0.1:8000/users/login";

  static Future<UserModel> loginUser(String email, String password) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }
}
