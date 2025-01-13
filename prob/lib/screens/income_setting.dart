import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:prob/screens/budget_setting.dart';
import 'package:prob/widgets/budgetIncome/budget_and_income_button.dart';
import 'package:prob/widgets/budgetIncome/budget_and_income_card.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';

class IncomeSetting extends StatefulWidget {
  const IncomeSetting({super.key});

  @override
  State<IncomeSetting> createState() => _IncomeSettingState();
}

class _IncomeSettingState extends State<IncomeSetting> {
  @override
  void initState() {
    super.initState();
    final incomeProvider = context.read<IncomeProvider>();
    final authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchIncomeWithAuthCheck(
        authProvider: authProvider,
        context: context,
        incomeProvider: incomeProvider,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFBF5),
      child: const Column(
        children: [
          MyPageHeader(
            title: '총 수입 설정',
          ),
          BudgetAndIncomeTopCard(title: "수입"),
          BudgetAndIncomeButton(
            title: '총 수입 변경',
          ),
          BudgetAndIncomeBottomCard(title: "수입"),
        ],
      ),
    );
  }

  void fetchIncomeWithAuthCheck(
      {required BuildContext context,
      required IncomeProvider incomeProvider,
      required AuthProvider authProvider}) async {
    if (incomeProvider.incomeData == null) {
      final authProvider = context.read<AuthProvider>();
      final accessToken = await authProvider.getToken();
      if (accessToken == 'fail' && context.mounted) {
        MyAlert.failShow(context, '로그인 만료', '/');
      }
    }
  }
}
