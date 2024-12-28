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
    return const Column(
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
    );
  }

  void fetchIncomeWithAuthCheck(
      {required BuildContext context,
      required IncomeProvider incomeProvider,
      required AuthProvider authProvider}) async {
    if (incomeProvider.incomeData == null) {
      final authProvider = context.read<AuthProvider>();
      bool isTokenValid = await authProvider.checkAndRefreshToken();
      if (isTokenValid) {
        final token = authProvider.accessToken;
        incomeProvider.fetchIncomeData(token);
      } else {
        if (context.mounted) {
          MyAlert.failShow(context, '다시 로그인 해주세요', '/');
        }
      }
    }
  }
}
