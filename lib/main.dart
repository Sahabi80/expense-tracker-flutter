import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/income_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/edit_expense_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nlwyadrhtvtsdzbvsulq.supabase.co',
    anonKey: 'sb_publishable_MBmLMvXh8Wf8eOZorfoN2Q_2ZrAEGDw',
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/income': (context) => const IncomeScreen(),
        '/add-expense': (context) => const AddExpenseScreen(),
      },
    );
  }
}
