import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/janji_temu.dart';

import 'package:poliklinik/widgets/loading_widget.dart';

import 'janji_add_page.dart';
import 'janji_edit_page.dart';

class JanjiListPage extends StatefulWidget {
  const JanjiListPage({super.key});

  @override
  State<JanjiListPage> createState() => _JanjiListPageState();
}

class _JanjiListPageState extends State<JanjiListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DataProvider>().fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Janji Temu",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const JanjiAddPage(),
            ),
          );
        },
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : ListView.builder(
              itemCount: controller.appointments.length,
              itemBuilder: (_, index) {
                JanjiTemu janji = controller.appointments[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                    ),
                    title: Text(
                      "Pasien ${janji.pasienId}",
                    ),
                    subtitle: Text(
                      "${janji.tanggal} | ${janji.jam}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            janji.status,
                          ),
                        ),
                        if (context.read<AuthProvider>().currentUser?.role != 'pasien') ...[
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JanjiEditPage(
                                    janji: janji,
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
                              await controller.deleteJanji(
                                janji.id!,
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
