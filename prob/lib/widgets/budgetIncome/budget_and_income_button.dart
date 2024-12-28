import 'package:flutter/material.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:provider/provider.dart';

class BudgetAndIncomeButton extends StatelessWidget {
  const BudgetAndIncomeButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF3B2304);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F1ED),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          onPressed: () {
            title == '예산'
                ? context.read<BudgetProvider>().toggleCanEdit()
                : context.read<IncomeProvider>().toggleCanEdit();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: textColor, fontSize: 15),
              ),
            ),
          )),
    );
  }
}
