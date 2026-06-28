import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';

class DokterPage extends StatefulWidget {
  const DokterPage({super.key});

  @override
  State<DokterPage> createState() => _DokterPageState();
}

class _DokterPageState extends State<DokterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dokter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.doctors.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(controller.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchDoctors(),
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }

          if (controller.doctors.isEmpty) {
            return const Center(child: Text('Belum ada data dokter'));
          }

          return ListView.builder(
            itemCount: controller.doctors.length,
            itemBuilder: (context, index) {
              final dokter = controller.doctors[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(dokter.nama[0].toUpperCase()),
                  ),
                  title: Text(dokter.nama),
                  subtitle: Text('Spesialis: ${dokter.spesialis}\nJadwal: ${dokter.jadwal}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Buat FormDokterPage
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
