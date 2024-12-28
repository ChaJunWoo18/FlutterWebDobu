import 'package:flutter/material.dart';
import 'package:prob/api/auth_api.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/service/provider_clear.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  static const logoImage = 'assets/images/logo.png';
  static const logoutImage = 'assets/images/logout.png';
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    void logout() async {
      AuthApi.logout(authProvider.accessToken);

      AuthHelper.clearProvider(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(logoImage, width: 70.5, height: 45, fit: BoxFit.contain),
          ElevatedButton(
            onPressed: logout,
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.white),
            child: Image.asset(
              logoutImage,
              width: 27.4,
              height: 27.4,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
