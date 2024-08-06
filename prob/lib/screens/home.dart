import 'package:flutter/material.dart';
import 'package:prob/api/get_budget.dart';
import 'package:prob/api/get_total_consume.dart';
import 'package:prob/model/budget_model.dart';
import 'package:prob/model/total_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/screens/consumption_history.dart';
import 'package:prob/screens/main_page.dart';
import 'package:prob/screens/profile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BudgetModel budget;
  late TotalModel total;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

//set되기 전에 get하는 문제로 사용불가. (totalCard에서 get시도  >> 결과 null)
  // void setData() async {
  //   final token = context.read<AuthProvider>().token;

  //   // BudgetProvider와 TotalProvider에 데이터 설정
  //   final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
  //   final totalProvider = Provider.of<TotalProvider>(context, listen: false);

  //   try {
  //     final budget = await GetBudget.readBudget(token);
  //     final total = await GetTotalConsume.readTotalConsume(token);
  //     budgetProvider.setBudget(budget);
  //     totalProvider.setTotal(total);
  //   } catch (e) {
  //     // 에러 처리
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token;

    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          GetBudget.readBudget(token),
          GetTotalConsume.readTotalConsume(token),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            budget = snapshot.data![0] as BudgetModel;
            total = snapshot.data![1] as TotalModel;

            return TabBarView(
              controller: _tabController,
              children: [
                MainPage(
                    budget: budget.budgetAmount,
                    total: total.monthTotal), // 페이지 1
                const Center(child: ConsumptionHistory()), // 페이지 2
                const Center(child: Profile()), // 페이지 3
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: const [
            Tab(
              icon: Icon(Icons.home),
              text: "메인",
            ),
            Tab(
              icon: Icon(Icons.attach_money_rounded),
              text: "소비 내역",
            ),
            Tab(
              icon: Icon(Icons.person),
              text: "내 정보",
            ),
          ],
        ),
      ),
    );
  }
}
