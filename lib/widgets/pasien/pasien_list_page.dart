import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/pasien.dart';

import 'package:poliklinik/widgets/loading_widget.dart';

import 'pasien_add_page.dart';
import 'pasien_edit_page.dart';
import 'pasien_detail_page.dart';

class PasienListPage extends StatefulWidget {
  const PasienListPage({super.key});

  @override
  State<PasienListPage> createState() => _PasienListPageState();
}

class _PasienListPageState extends State<PasienListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DataProvider>().fetchPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pasien"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PasienAddPage(),
            ),
          );
        },
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : ListView.builder(
              itemCount: controller.patients.length,
              itemBuilder: (_, index) {
                Pasien pasien = controller.patients[index];

                return Card(
                  child: ListTile(
                    title: Text(pasien.nama),
                    subtitle: Text(pasien.telepon),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PasienDetailPage(
                            pasien: pasien,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PasienEditPage(
                                  pasien: pasien,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () async {
                            await controller.deletePasien(
                              pasien.id!,
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
