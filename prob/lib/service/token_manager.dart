import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenManager {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }

  bool isTokenExpired(String? token) {
    if (token == null) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      if (!payloadMap.containsKey('exp')) return true;

      final exp = payloadMap['exp'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
      return currentTime >= exp;
    } catch (e) {
      return true;
    }
  }
}
