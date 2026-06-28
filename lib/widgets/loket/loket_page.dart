import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/pembayaran.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';
import 'package:poliklinik/widgets/loading_widget.dart';
import 'pembayaran_validasi_page.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';

class LoketPage extends StatefulWidget {
  const LoketPage({super.key});

  @override
  State<LoketPage> createState() => _LoketPageState();
}

class _LoketPageState extends State<LoketPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<DataProvider>().fetchPembayaran();
    });

    eventBus.stream.listen((event) {
      if (event.name == 'ObatDisiapkan' && mounted) {
        context.read<DataProvider>().fetchPembayaran();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DataProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    List<Pembayaran> displayList = controller.pembayaranList;
    if (user?.role.toLowerCase() == 'pasien') {
      displayList = displayList.where((p) => p.pasienNama.toLowerCase() == user!.name.toLowerCase()).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Loket Pembayaran"),
      ),
      body: controller.isLoading
          ? const LoadingWidget()
          : displayList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('Database Pembayaran Kosong', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Form Input Manual Loket sedang dalam pengembangan')),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Input Pembayaran Manual'),
                      )
                    ],
                  ),
                )
              : ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                Pembayaran pembayaran = displayList[index];
                
                bool isLunas = pembayaran.statusValidasi == 'Lunas';
                bool menungguValidasi = pembayaran.statusValidasi == 'Menunggu Validasi';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLunas ? Colors.green : (menungguValidasi ? Colors.orange : Colors.blue),
                      child: const Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    title: Text(pembayaran.pasienNama),
                    subtitle: Text('Total: Rp ${pembayaran.totalBiaya} | Status: ${pembayaran.statusValidasi}'),
                    trailing: isLunas
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : menungguValidasi
                            ? ElevatedButton(
                                onPressed: () async {
                                  // Validate bill
                                  pembayaran.statusValidasi = 'Belum Lunas';
                                  await context.read<DataProvider>().updatePembayaran(pembayaran);
                                  eventBus.publish(AppEvent('TagihanDibuat', pembayaran.id));
                                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tagihan Divalidasi. Dikirim ke Pasien.')));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                child: const Text('Validasi & Kirim', style: TextStyle(color: Colors.white)),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  // If already Belum Lunas but we want to simulate or check
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PembayaranValidasiPage(pembayaran: pembayaran),
                                    ),
                                  );
                                },
                                child: const Text('Detail'),
                              ),
                  ),
                );
              },
            ),
    );
  }
}
