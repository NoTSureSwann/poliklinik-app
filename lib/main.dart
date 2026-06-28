import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/api_client.dart';
import 'cqrs/command/auth_command.dart';
import 'cqrs/command/appointment_command.dart';
import 'cqrs/query/appointment_query.dart';
import 'cqrs/query/doctor_query.dart';
import 'cqrs/query/patient_query.dart';
import 'cqrs/query/dashboard_query.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'routes/app_routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed. Please run 'flutterfire configure' to set up Firebase options.");
  }
  
  runApp(const PoliKlinikApp());
}

class PoliKlinikApp extends StatelessWidget {
  const PoliKlinikApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize core services
    final apiClient = ApiClient();
    final authCommand = AuthCommandHandler(apiClient);
    final apptQuery = AppointmentQueryHandler(apiClient);
    final apptCommand = AppointmentCommandHandler(apiClient);
    final doctorQuery = DoctorQueryHandler(apiClient);
    final patientQuery = PatientQueryHandler(apiClient);
    final dashboardQuery = DashboardQueryHandler(apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authCommand)),
        ChangeNotifierProvider(
          create: (_) => DataProvider(
            apptQuery,
            apptCommand,
            doctorQuery,
            patientQuery,
            dashboardQuery,
          ),
        ),
      ],
      child: const PoliKlinikAppBody(),
    );
  }
}

class PoliKlinikAppBody extends StatelessWidget {
  const PoliKlinikAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poliklinik Enterprise',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
