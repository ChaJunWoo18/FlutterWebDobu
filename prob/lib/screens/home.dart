import 'package:flutter/material.dart';
import 'package:prob/screens/consumption_history.dart';
import 'package:prob/screens/profile.dart';
import 'package:prob/widgets/home_body.dart';
import 'package:prob/widgets/home_header.dart';
import 'package:prob/widgets/total_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(),
                TotalCard(),
                SizedBox(
                  height: 25,
                ),
                HomeBody(),
              ],
            ),
          ),
          Center(child: ConsumptionHistory()), // 페이지 2
          Center(child: Profile()), // 페이지 3
        ],
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
