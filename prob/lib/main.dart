import 'package:flutter/material.dart';
import 'package:prob/provider/add_provider.dart';
import 'package:prob/provider/barchart/chart_provider.dart';
import 'package:prob/provider/card_provider.dart';
import 'package:prob/provider/fixed_provider.dart';
import 'package:prob/provider/graph_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:prob/provider/loading_provider.dart';
import 'package:prob/provider/main_page/calendar_provider.dart';
import 'package:prob/provider/main_page/card_option_provider.dart';
import 'package:prob/provider/saving_provider.dart';
import 'package:prob/provider/signup/categories_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prob/screens/edit_category.dart';
import 'package:prob/screens/home.dart';
import 'package:prob/screens/sign_up_page.dart';
import 'package:prob/screens/start_page.dart';
import 'package:provider/provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/signup/email_provider.dart';
import 'package:prob/provider/signup/nickname_provider.dart';
import 'package:prob/provider/signup/passwd_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting().then((_) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => BudgetProvider()),
            ChangeNotifierProvider(create: (_) => TotalProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
            ChangeNotifierProvider(create: (_) => SignupProvider()),
            ChangeNotifierProvider(create: (_) => EmailProvider()),
            ChangeNotifierProvider(create: (_) => PasswdProvider()),
            ChangeNotifierProvider(create: (_) => NicknameProvider()),
            ChangeNotifierProvider(create: (_) => CategoriesProvider()),
            ChangeNotifierProvider(create: (_) => MainLoadingProvider()),
            ChangeNotifierProvider(create: (_) => ProfileLoadingProvider()),
            ChangeNotifierProvider(create: (_) => ConsumeHistLoadingProvider()),
            ChangeNotifierProvider(create: (_) => ChartProvider()),
            ChangeNotifierProvider(create: (_) => AddProvider()),
            ChangeNotifierProvider(create: (_) => CardOptionProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => CalendarProvider()),
            ChangeNotifierProvider(create: (_) => CardProvider()),
            ChangeNotifierProvider(create: (_) => FixedProvider()),
            ChangeNotifierProvider(create: (_) => SavingProvider()),
            ChangeNotifierProvider(create: (_) => IncomeProvider()),
            ChangeNotifierProvider(create: (_) => GraphProvider()),
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.white, //const Color.fromARGB(202, 255, 255, 255),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xffFFEECC),
          ),
        ),
        cardColor: const Color.fromARGB(255, 206, 122, 143),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/home': (context) => const Home(),
        // '/home/calendar_month': (context) => const CalendarPage(),
        // '/home/chart_month': (context) => const Chart(),
        // '/history': (context) => const ConsumptionHistory(),
        '/my_page/category.edit': (context) => const EditCategory(),
        '/join_first': (context) => const SignUpPage1(),
        '/join_second': (context) => const SignUpPage2(),
        '/join_third': (context) => const SignUpPage3(),
        '/join_end': (context) => const SignUpEnd(),
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}
