import 'package:flutter/material.dart';
// Ensure the provider package is included in your pubspec.yaml file under dependencies
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/rekam_medis.dart';
import 'package:poliklinik/models/pasien.dart';
import 'package:poliklinik/models/dokter.dart';
import 'package:poliklinik/services/pdf_service.dart';
import 'package:poliklinik/widgets/loading_widget.dart';

import 'rekam_add_page.dart';
import 'rekam_detail_page.dart';

class RekamListPage extends StatefulWidget {
  const RekamListPage({super.key});

  @override
  State<RekamListPage> createState() => _RekamListPageState();
}

class _RekamListPageState extends State<RekamListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DataProvider>().fetchRekam();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekam Medis"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RekamAddPage(),
            ),
          );
        },
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : ListView.builder(
              itemCount: controller.rekamList.length,
              itemBuilder: (context, index) {
                RekamMedis rekam = controller.rekamList[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.description,
                    ),
                    title: Text(
                      rekam.diagnosa,
                    ),
                    subtitle: Text(
                      rekam.tanggal,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RekamDetailPage(
                            rekam: rekam,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
                          onPressed: () async {
                            // Find Pasien & Dokter from providers if available
                            final pasienCtrl = context.read<DataProvider>();
                            final dokterCtrl = context.read<DataProvider>();
                            
                            final patients = pasienCtrl.patients;
                            final doctors = dokterCtrl.doctors;

                            final pasien = patients.isNotEmpty 
                                ? patients.cast<Pasien?>().firstWhere((p) => p?.id == rekam.pasienId, orElse: () => null)
                                : null;
                            final dokter = doctors.isNotEmpty
                                ? doctors.cast<Dokter?>().firstWhere((d) => d?.id == rekam.dokterId, orElse: () => null)
                                : null;

                            await PdfService.printRekamMedis(rekam, pasien, dokter);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await controller.deleteRekam(
                              rekam.id!,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
