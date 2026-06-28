import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/obat.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';
import 'package:poliklinik/widgets/loading_widget.dart';
import 'obat_add_page.dart';

class FarmasiPage extends StatefulWidget {
  const FarmasiPage({super.key});

  @override
  State<FarmasiPage> createState() => _FarmasiPageState();
}

class _FarmasiPageState extends State<FarmasiPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DataProvider>().fetchObat();
        context.read<DataProvider>().fetchRekam();
      }
    });

    eventBus.stream.listen((event) {
      if (event.name == 'DiagnosaSelesai') {
        if (mounted) context.read<DataProvider>().fetchRekam();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard Farmasi", style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          bottom: const TabBar(
            indicatorWeight: 4,
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: "Antrean Resep"),
              Tab(icon: Icon(Icons.medication), text: "Katalog Obat"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAntreanResep(context),
            _buildStokObat(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAntreanResep(BuildContext context) {
    final rekamCtrl = context.watch<DataProvider>();
    
    if (rekamCtrl.isLoading) return const LoadingWidget();

    final antrean = rekamCtrl.rekamList.where((r) => r.statusFlow == 'Menunggu Farmasi').toList();

    if (antrean.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 16),
            Text("Tidak ada antrean resep saat ini", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: antrean.length,
      itemBuilder: (context, index) {
        final rekam = antrean[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pasien ID: ${rekam.pasienId}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Chip(
                      label: const Text("Menunggu Obat"),
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
                    )
                  ],
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.medical_services),
                  ),
                  title: Text("Diagnosa: ${rekam.diagnosa}"),
                  subtitle: Text("Catatan: ${rekam.catatanDokter}"),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Validasi & Berikan Obat"),
                    onPressed: () => _showProsesResepDialog(context, rekam),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProsesResepDialog(BuildContext context, dynamic rekam) {
    final obatCtrl = context.read<DataProvider>();
    Obat? selectedObat = obatCtrl.obatList.isNotEmpty ? obatCtrl.obatList.first : null;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Validasi Obat"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pilih obat untuk diberikan kepada pasien:"),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Obat>(
                    value: selectedObat,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    isExpanded: true,
                    items: obatCtrl.obatList.map((obat) {
                      return DropdownMenuItem(
                        value: obat,
                        child: Text("${obat.nama} (Stok: ${obat.stok})"),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedObat = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                FilledButton(
                  onPressed: selectedObat == null ? null : () async {
                    Navigator.pop(context); 
                    
                    rekam.obat = selectedObat!.nama;
                    rekam.statusFlow = 'Selesai';
                    
                    await context.read<DataProvider>().updateRekam(rekam);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resep berhasil diproses! Pasien selesai.")));
                    }
                  },
                  child: const Text("Selesai & Serahkan Obat"),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget _buildStokObat(BuildContext context) {
    final controller = context.watch<DataProvider>();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah Obat"),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ObatAddPage())),
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.obatList.length,
              itemBuilder: (context, index) {
                Obat obat = controller.obatList[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Icon(Icons.medication, size: 48, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(obat.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(obat.kategori, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Stok: ${obat.stok}", style: const TextStyle(fontWeight: FontWeight.w600)),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () async => await controller.deleteObat(obat.id!),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
