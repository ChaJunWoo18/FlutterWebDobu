import 'package:flutter/material.dart';
import 'package:prob/api/budget_api.dart';
import 'package:prob/api/total_consume_api.dart';
import 'package:prob/api/user_api.dart';
import 'package:prob/model/user_model.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/loading_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/main_page/calendar_button.dart';
import 'package:prob/widgets/main_page/main_card.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final AuthProvider authProvider;
  late final UserProvider userProvider;
  late final BudgetProvider budgetProvider;
  late final TotalProvider totalProvider;
  late final CategoryProvider categoryProvider;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLoadData();
    });
  }

  Future<void> _checkAndLoadData() async {
    final MainLoadingProvider loadingProvider =
        context.read<MainLoadingProvider>();

    final accessToken = await context.read<AuthProvider>().getToken();
    if (accessToken == 'fail' && context.mounted) {
      MyAlert.failShow(context, '로그인 만료', '/');
    }

    _fetchData(accessToken);

    loadingProvider.setError("다시 로그인 해주세요");
  }

  Future<void> _fetchData(String accessToken) async {
    //loading
    final MainLoadingProvider loadingProvider =
        context.read<MainLoadingProvider>();
    loadingProvider.setLoading(true);
    loadingProvider.setError(null);

    try {
      userProvider = context.read<UserProvider>();
      budgetProvider = context.read<BudgetProvider>();
      totalProvider = context.read<TotalProvider>();

      if (userProvider.user == null) {
        final user = await UserApi.readUser(accessToken);
        userProvider.setUser(user);
      }

      if (budgetProvider.budgetData == null) {
        final budgetData = await BudgetApi.readBudget(accessToken);
        budgetProvider.setBudget(budgetData);
      }

      final monthTotal =
          await TotalConsumeApi.readPreiodTotalMWD('month', accessToken);
      final weekTotal =
          await TotalConsumeApi.readPreiodTotalMWD('week', accessToken);
      totalProvider.setMonthTotal(monthTotal);
      totalProvider.setWeekTotal(weekTotal);
      final budget = budgetProvider.budgetData!.curBudget;

      budgetProvider.setRemainBudget(
        curBudget: budget,
        weekTotal: totalProvider.weekTotal ?? 0,
        monthTotal: totalProvider.monthTotal ?? 0,
      );
    } catch (e) {
      loadingProvider.setError("데이터 가져오기 실패!");
    } finally {
      loadingProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFFFBF5)),
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 37, horizontal: 15),
          child: Column(
            children: [
              MainCard(),
              SizedBox(height: 37),
              CalendarButton(),
            ],
          ),
        ),
      ),
    );
  }
}
