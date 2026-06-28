import 'package:flutter/material.dart';
// Ensure the provider package is added in your pubspec.yaml dependencies
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // Ensure there is a RekamController provided above this widget in the widget tree
      final controller = context.read<DataProvider>();
      controller.fetchRekam();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
      ),
      body: ListView.builder(
        itemCount: controller.rekamList.length,
        itemBuilder: (_, index) {
          final rekam = controller.rekamList[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.analytics),
              title: Text(rekam.diagnosa),
              subtitle: Text(rekam.tanggal),
            ),
          );
        },
      ),
    );
  }
}
