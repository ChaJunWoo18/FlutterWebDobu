import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/card_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/fixed_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:prob/provider/main_page/calendar_provider.dart';
import 'package:prob/provider/saving_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AuthHelper {
  static Future<void> clearProvider(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final totalProvider = context.read<TotalProvider>();
    final cardProvider = context.read<CardProvider>();
    final savingProvider = context.read<SavingProvider>();
    final incomeProvider = context.read<IncomeProvider>();
    final homeProvider = context.read<HomeProvider>();
    final calendarProvider = context.read<CalendarProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final fixedProvider = context.read<FixedProvider>();

    await categoryProvider.immediateSync(context);
    userProvider.clearUser();
    await authProvider.logout();
    totalProvider.clear();
    budgetProvider.clear();
    calendarProvider.clear();
    cardProvider.clear();
    savingProvider.clear();
    incomeProvider.clear();
    fixedProvider.clear();

    homeProvider.reset();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
