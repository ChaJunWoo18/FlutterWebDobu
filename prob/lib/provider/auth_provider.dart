import 'package:flutter/material.dart';
import 'package:prob/api/auth_api.dart';
import 'package:prob/service/token_manager.dart';

class AuthProvider with ChangeNotifier {
  final TokenManager _tokenManager = TokenManager();

  // String? _accessToken;
  // String? _refreshToken;

  // String? get accessToken => _accessToken;
  // String? get refreshToken => _refreshToken;

  Future<bool> login(String email, String password) async {
    try {
      final response = await AuthApi.getAccessToken(email, password);
      // print(response);
      // _accessToken = response.accessToken;
      // _refreshToken = response.refreshToken;

      await _tokenManager.saveTokens(
          response.accessToken, response.refreshToken);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenManager.clearTokens();
    // _accessToken = null;
    // _refreshToken = null;
    notifyListeners();
  }

  Future<String> getToken() async {
    final storedAccessToken = await _tokenManager.getAccessToken();
    final storedRefreshToken = await _tokenManager.getRefreshToken();

    if (_tokenManager.isTokenExpired(storedAccessToken)) {
      try {
        final response = await AuthApi.refreshToken(storedRefreshToken!);
        // _accessToken = response.accessToken;
        await _tokenManager.saveTokens(
            response.accessToken, storedRefreshToken);

        notifyListeners();
        return storedAccessToken!;
      } catch (e) {
        await logout();
        return 'fail';
      }
    } else {
      notifyListeners();
      return storedAccessToken!;
    }
  }
}
