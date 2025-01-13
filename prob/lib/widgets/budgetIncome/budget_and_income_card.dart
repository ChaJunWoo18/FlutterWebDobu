import 'package:flutter/material.dart';
import 'package:prob/api/budget_api.dart';
import 'package:prob/api/income_api.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/main_page/calendar_widget.dart';
import 'package:provider/provider.dart';

class BudgetAndIncomeTopCard extends StatelessWidget {
  const BudgetAndIncomeTopCard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final incomeProvider = context.watch<IncomeProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    const textColor = Color(0xFF3B2304);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 75 / 2, horizontal: 34 / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 설정되어 있는 한 달 $title은',
                style: const TextStyle(color: textColor, fontSize: 15),
              ),
              const SizedBox(height: 22),
              Text(
                title == '예산'
                    ? '${budgetProvider.formatNumberWithComma(budgetProvider.budgetData?.curBudget ?? 0)} 원'
                    : '${incomeProvider.formatNumberWithComma(incomeProvider.incomeData?.curIncome ?? 0)} 원',
                style: const TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 26),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFFF3ECE1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '지난달 설정했던 $title은',
                        style: const TextStyle(color: textColor, fontSize: 13),
                      ),
                      Text(
                        title == '예산'
                            ? '${budgetProvider.formatNumberWithComma(budgetProvider.budgetData?.preBudget ?? 0)} 원'
                            : '${incomeProvider.formatNumberWithComma(incomeProvider.incomeData?.preIncome ?? 0)} 원',
                        style: const TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetAndIncomeBottomCard extends StatelessWidget {
  const BudgetAndIncomeBottomCard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF3B2304);
    final budgetProvider = context.watch<BudgetProvider>();
    final incomeProvider = context.watch<IncomeProvider>();
    final nextBudget = budgetProvider.nextBudget ?? 0;
    final nextIncome = incomeProvider.nextIncome ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '변경하고 싶은 한 달 $title은',
              style: const TextStyle(fontSize: 15, color: textColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title == '예산'
                    ? budgetProvider.canEdit
                        ? _buildTextFiled(budgetProvider)
                        : _buildText(budgetProvider, textColor, nextBudget)
                    : incomeProvider.canEdit
                        ? _buildTextFiled(incomeProvider)
                        : _buildText(incomeProvider, textColor, nextIncome),
                const SizedBox(height: 18),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5366DF),
                      minimumSize: const Size(100, 30),
                    ),
                    onPressed: () async {
                      final authProvider = context.read<AuthProvider>();
                      title == '예산'
                          ? budgetAndIncomeMethod(
                              budgetProvider, authProvider, context)
                          : budgetAndIncomeMethod(
                              incomeProvider, authProvider, context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Center(
                          child: Text(
                        '저장',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      )),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void budgetAndIncomeMethod(
      provider, AuthProvider authProvider, BuildContext context) async {
    if (provider.canEdit) {
      if (provider.validNextValue()) {
        final accessToken = await context.read<AuthProvider>().getToken();
        if (accessToken == 'fail' && context.mounted) {
          MyAlert.failShow(context, '로그인 만료', '/');
        }

        try {
          if (provider is BudgetProvider) {
            final newBudget = int.parse(provider.controller.text);
            final saved = await BudgetApi.updateBudget(accessToken, newBudget);
            provider.setBudget(saved);
            provider.reset();
            provider.updateRemainBudget(newBudget: newBudget);
          } else {
            final newIncome = int.parse(provider.controller.text);

            final saved = await IncomeApi.updateIncome(accessToken, newIncome);
            provider.setIncome(saved);
            provider.reset();
          }

          if (context.mounted) {
            showCustomSnackBar(context, '저장 완료');
            provider.toggleCanEdit();
          }
        } catch (e) {
          if (context.mounted) {
            MyAlert.failShow(context, '요청 실패', null);
          }
        }
      }
    } else {
      provider.toggleCanEdit();
    }
  }

  Widget _buildText(provider, textColor, nextValue) {
    return Text(
      '${provider.formatNumberWithComma(nextValue)} 원',
      style: TextStyle(
          fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextFiled(provider) {
    return SizedBox(
      width: 130,
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          errorText: provider.errorText,
          errorStyle: const TextStyle(fontSize: 11),
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 8, bottom: 8, left: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 136, 81, 10),
              width: 1.5,
            ),
          ),
        ),
        controller: provider.controller,
      ),
    );
  }
}
