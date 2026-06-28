import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    
    if (auth.isAuthenticated) {
      if (auth.role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else if (auth.role == 'dokter') {
        Navigator.pushReplacementNamed(context, AppRoutes.doctorDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.patientDashboard);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            const Text(
              'Poliklinik Enterprise',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
