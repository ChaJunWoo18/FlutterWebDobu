import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryApi {
  static String baseUrl = "http://127.0.0.1:8000/category";

  static Future<List<String>> readCategories(String? token) async {
    const extraUrl = '/categories';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<String> categories =
          List<String>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      return categories;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}

class CategoryAddApi {
  static String baseUrl = "http://127.0.0.1:8000/category";

  static Future<dynamic> addItem(String addItemName, String? token) async {
    const extraUrl = '/add';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": addItemName}));

    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}

class CategoryRemoveApi {
  static String baseUrl = "http://127.0.0.1:8000/category";

  static Future<dynamic> removeItem(
      String removeItemName, String? token) async {
    const extraUrl = '/del/one';
    final url = Uri.parse('$baseUrl$extraUrl/$removeItemName');
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      //print(response.body);
      return response.body;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}
