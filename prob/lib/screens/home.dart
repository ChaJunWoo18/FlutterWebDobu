import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/screens/budget_setting.dart';
import 'package:prob/screens/calendar_page.dart';
import 'package:prob/screens/edit_category.dart';
import 'package:prob/screens/fixed_consume.dart';
import 'package:prob/screens/graph_page.dart';
import 'package:prob/screens/income_setting.dart';
import 'package:prob/screens/main_page.dart';
import 'package:prob/screens/profile.dart';
import 'package:prob/screens/saving.dart';
import 'package:prob/widgets/common/header.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //변경 리스너
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  void _onTabChanged(int index) {
    final prov = context.read<CategoryProvider>();
    prov.immediateSync(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = context.watch<HomeProvider>();
    final List<Widget> pages = [
      homeProvider.homeWidget == 'mainPage'
          ? const MainPage()
          : homeProvider.homeWidget == 'calendarPage'
              ? const CalendarPage()
              : const GraphPage(),
      const Saving(),
      _buildProfilePage(homeProvider.profile),
    ];
    const List<Tab> tabs = [
      Tab(text: "메인"),
      Tab(text: "저축 내역"),
      Tab(text: "마이 페이지"),
    ];
    return Scaffold(
      body: HeaderNavigator(
          tabController: _tabController, tabs: tabs, pages: pages),
    );
  }

  Widget _buildProfilePage(String profile) {
    switch (profile) {
      case 'profile':
        return const Profile();
      case 'edit_category':
        return const EditCategory();
      case 'fixed_consume':
        return const FixedConsume();
      case 'budget_setting':
        return const BudgetSetting();
      case 'income_setting':
        return const IncomeSetting();
      default:
        return const Profile();
    }
  }
}

class HeaderNavigator extends StatelessWidget {
  const HeaderNavigator({
    super.key,
    required TabController tabController,
    required List<Tab> tabs,
    required List<Widget> pages,
  })  : _tabController = tabController,
        _tabs = tabs,
        _pages = pages;

  final TabController _tabController;
  final List<Tab> _tabs;
  final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),
        SizedBox(
          height: 55,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF3B2304),
            labelStyle: const TextStyle(
                color: Color(0xFF3B2304),
                fontSize: 18,
                fontWeight: FontWeight.bold),
            tabs: _tabs,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: const Color(0xFF367E3E),
            indicatorWeight: 4,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _pages,
          ),
        ),
      ],
    );
  }
}
