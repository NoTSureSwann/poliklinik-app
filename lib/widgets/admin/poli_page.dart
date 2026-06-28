import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/poli.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({Key? key}) : super(key: key);

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchPolis();
    });
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Poli'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Poli'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && descController.text.isNotEmpty) {
                  final newPoli = Poli(
                    id: '', // Generated in controller
                    nama: nameController.text,
                    deskripsi: descController.text,
                  );
                  Navigator.pop(context); // Close dialog first
                  await context.read<DataProvider>().addPoli(newPoli);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Poli berhasil ditambahkan!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kelola Poli',
                  style: AppTextStyle.heading2.copyWith(color: AppColors.textPrimary),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Poli'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<DataProvider>(
                builder: (context, controller, child) {
                  if (controller.isLoading && controller.polis.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.polis.isEmpty) {
                    return const Center(child: Text('Belum ada data Poli.'));
                  }

                  return ListView.builder(
                    itemCount: controller.polis.length,
                    itemBuilder: (context, index) {
                      final poli = controller.polis[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(poli.nama, style: AppTextStyle.heading3),
                          subtitle: Text(poli.deskripsi, style: AppTextStyle.body2),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Poli'),
                                  content: Text('Apakah Anda yakin ingin menghapus ${poli.nama}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await controller.deletePoli(poli.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Poli ${poli.nama} berhasil dihapus!'),
                                              backgroundColor: AppColors.success,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
