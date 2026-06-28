import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../widgets/auth/login_page.dart';
import '../widgets/dashboard/dashboard_page.dart';
import '../widgets/dokter/dokter_page.dart';
import '../widgets/pasien/pasien_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String patientDashboard = '/patient-dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => LoginPage(),
    adminDashboard: (context) => DashboardPage(),
    // Fallback if specific dashboards aren't fully implemented in the new structure yet
    doctorDashboard: (context) => const DokterPage(), 
    patientDashboard: (context) => const PasienPage(),
  };
}
