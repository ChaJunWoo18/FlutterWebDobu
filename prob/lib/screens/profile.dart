import 'package:flutter/material.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    void logout() {
      userProvider.clearUser();
      Navigator.pushReplacementNamed(context, '/');
    }

    return Expanded(
      child: Column(
        children: [
          TextButton(
            onPressed: logout,
            child: const Text("logout"),
          ),
        ],
      ),
    );
  }
}
