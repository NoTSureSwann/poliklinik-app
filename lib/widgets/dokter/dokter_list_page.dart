import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/dokter.dart';

import 'package:poliklinik/widgets/loading_widget.dart';

import 'dokter_add_page.dart';
import 'dokter_edit_page.dart';
import 'dokter_detail_page.dart';

class DokterListPage extends StatefulWidget {
  const DokterListPage({super.key});

  @override
  State<DokterListPage> createState() => _DokterListPageState();
}

class _DokterListPageState extends State<DokterListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DataProvider>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Dokter"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DokterAddPage(),
            ),
          );
        },
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : ListView.builder(
              itemCount: controller.doctors.length,
              itemBuilder: (_, index) {
                Dokter dokter = controller.doctors[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.medical_services,
                    ),
                    title: Text(dokter.nama),
                    subtitle: Text(dokter.spesialis),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DokterDetailPage(
                            dokter: dokter,
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
                                builder: (_) => DokterEditPage(
                                  dokter: dokter,
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
                            await controller.deleteDokter(
                              dokter.id!,
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
