import 'package:flutter/material.dart';
import 'package:prob/api/get_user.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/widgets/custom_alert.dart';
import 'package:prob/widgets/home_body.dart';
import 'package:prob/widgets/home_header.dart';
import 'package:prob/widgets/total_card.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, this.budget, this.total});
  final budget;
  final total;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    Future<Map<String, dynamic>> user = GetUser.readUser(token);

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: FutureBuilder<Map<String, dynamic>>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text("로그인 만료"),
              content: const Text("다시 로그인 해주세요."),
              actions: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              TotalCard(
                  budget: budget, total: total, remainedBudget: budget - total),
              const SizedBox(
                height: 25,
              ),
              HomeBody(user: snapshot.data),
            ],
          );
        },
      ),
    );
  }
}
