import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/look_list_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:prob/screens/consumption_history.dart';
import 'package:prob/screens/home.dart';
import 'package:prob/screens/start_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LookListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TotalProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffFEBBCC),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color.fromARGB(255, 206, 122, 143),
          ),
        ),
        cardColor: const Color(0xffFFEECC),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/home': (context) => const Home(),
        '/history': (context) => const ConsumptionHistory(),
        //'/settings': (context) => SettingsScreen(),
      },
    );
  }
}
