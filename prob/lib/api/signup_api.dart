import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupApi {
  static String baseUrl = "https://dobu.kro.kr/mail";

  static Future<bool> signUp(String userId, String password) async {
    const extraUrl = '/signup';
    final url = Uri.parse('/users$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": userId,
          "password": password,
        }));

    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else {
      return false;
      //throw Exception('get user failed. Token may have expired');
    }
  }

  //인증번호 발급
  static Future<bool> createValidEmailNum(String email) async {
    const extraUrl = '/send/verify/email/background';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": [email],
        }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> validEmailNum(
    String email,
    String validCode,
  ) async {
    const extraUrl = '/verify/email_code';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email, "input_code": validCode}));

    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else {
      return false;
      //throw Exception('get user failed. Token may have expired');
    }
  }

  static Future<bool> checkId(String userId) async {
    const extraUrl = '/check_use/email';
    final url = Uri.parse('/users$extraUrl?email=$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Error,관리자에게 문의하세요');
    }
  }

  static Future<bool> checkNickname(String nickname) async {
    const extraUrl = '/check_use/nickname';
    final url = Uri.parse('/users$extraUrl?nickname=$nickname');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Error,관리자에게 문의하세요');
    }
  }
}
