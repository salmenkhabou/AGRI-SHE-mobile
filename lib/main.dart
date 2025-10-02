import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/landing_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/signup_page.dart';
import 'screens/dashboard/farmer_dashboard.dart';
import 'screens/marketplace/marketplace_page.dart';
import 'screens/opportunities/opportunities_hub.dart';
import 'screens/profile/profile_page.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/task_provider.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const AgriSHEApp());
}

class AgriSHEApp extends StatelessWidget {
  const AgriSHEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Agri-SHE',
        theme: AppTheme.lightTheme,
        home: const LandingPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/dashboard': (context) => const FarmerDashboard(),
          '/marketplace': (context) => const MarketplacePage(),
          '/opportunities': (context) => const OpportunitiesHub(),
          '/profile': (context) => const ProfilePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


