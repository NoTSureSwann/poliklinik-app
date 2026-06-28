import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';

class DashboardStatistikPage extends StatefulWidget {
  const DashboardStatistikPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardStatistikPage> createState() => _DashboardStatistikPageState();
}

class _DashboardStatistikPageState extends State<DashboardStatistikPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<DataProvider>().fetchPatients();
      await context.read<DataProvider>().fetchDoctors();
      await context.read<DataProvider>().fetchAppointments();
      await context.read<DataProvider>().fetchRekam();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pasien = context.watch<DataProvider>();
    final dokter = context.watch<DataProvider>();
    final janji = context.watch<DataProvider>();
    final rekam = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Statistik"),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        children: [
          _card("Pasien", pasien.patients.length.toString(), Icons.people),
          _card("Dokter", dokter.doctors.length.toString(),
              Icons.medical_services),
          _card(
              "Janji", janji.appointments.length.toString(), Icons.calendar_month),
          _card("Rekam", rekam.rekamList.length.toString(), Icons.description),
        ],
      ),
    );
  }

  Widget _card(String title, String value, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}
