import 'package:flutter/material.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/widgets/budgetIncome/budget_and_income_button.dart';
import 'package:prob/widgets/budgetIncome/budget_and_income_card.dart';
import 'package:provider/provider.dart';

class BudgetSetting extends StatelessWidget {
  const BudgetSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFBF5),
      height: MediaQuery.of(context).size.height,
      child: const Column(
        children: [
          MyPageHeader(
            title: '예산 설정',
          ),
          BudgetAndIncomeTopCard(title: "예산"),
          BudgetAndIncomeButton(
            title: '예산 변경',
          ),
          BudgetAndIncomeBottomCard(title: "예산"),
        ],
      ),
    );
  }
}

class MyPageHeader extends StatelessWidget {
  const MyPageHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 16),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                context.read<HomeProvider>().setProfile('profile');
              },
              icon: const Icon(Icons.keyboard_backspace)),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF3B2304), fontSize: 18),
          )
        ],
      ),
    );
  }
}
