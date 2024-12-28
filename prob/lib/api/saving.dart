import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prob/model/saving_model.dart';

class SavingApi {
  static String baseUrl = "http://localhost:8000/saving";

  static Future<List<GroupedSavings>> getSaving(String? token) async {
    final url = Uri.parse('$baseUrl/group/data');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      // print(jsonData);
      List<GroupedSavings> groupedSavings = jsonData.entries.map((entry) {
        final String month = entry.key.toString();
        final List<dynamic> savings = entry.value as List<dynamic>;
        return GroupedSavings.fromJson(month, savings);
      }).toList();
      return groupedSavings;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  static Future<List<GroupedSavings>> removeSaving(
      int itemId, String? token) async {
    final url = Uri.parse('$baseUrl/del/saving/$itemId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      // print(jsonData);
      List<GroupedSavings> groupedSavings = jsonData.entries.map((entry) {
        final String month = entry.key.toString();
        final List<dynamic> savings = entry.value as List<dynamic>;
        return GroupedSavings.fromJson(month, savings);
      }).toList();
      return groupedSavings;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  static Future<List<GroupedSavings>> addSaving(
      SavingModel savingModel, String? token) async {
    const extraUrl = '/add/data';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(savingModel.toJson()));
    // jsonEncode({
    //   "date": savingModel.date,
    //   "receiver": savingModel.receiver,
    //   "amount": int.parse(savingModel.amount),
    // }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      List<GroupedSavings> groupedSavings = jsonData.entries.map((entry) {
        final String month = entry.key.toString();
        final List<dynamic> savings = entry.value as List<dynamic>;
        return GroupedSavings.fromJson(month, savings);
      }).toList();
      return groupedSavings;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }
}
