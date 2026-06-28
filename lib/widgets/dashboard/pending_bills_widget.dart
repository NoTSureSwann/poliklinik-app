import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/widgets/loket/pembayaran_validasi_page.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';
import 'package:poliklinik/widgets/states/empty_state_widget.dart';

class PendingBillsWidget extends StatefulWidget {
  const PendingBillsWidget({Key? key}) : super(key: key);

  @override
  State<PendingBillsWidget> createState() => _PendingBillsWidgetState();
}

class _PendingBillsWidgetState extends State<PendingBillsWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<DataProvider>().fetchPembayaran();
    });

    eventBus.stream.listen((event) {
      if (event.name == 'TagihanDibuat' && mounted) {
        context.read<DataProvider>().fetchPembayaran();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final controller = context.watch<DataProvider>();

    if (auth.currentUser?.role != 'pasien') return const SizedBox.shrink();

    // Filter by auth.currentUser.name
    final pendingBills = controller.pembayaranList.where((p) => 
      p.statusValidasi == 'Belum Lunas' && p.pasienNama.toLowerCase() == auth.currentUser!.name.toLowerCase()
    ).toList();

    if (pendingBills.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.receipt_long,
        title: 'Tidak Ada Tagihan',
        message: 'Yeay! Saat ini Anda tidak memiliki tagihan yang perlu dibayar.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tagihan Menunggu Pembayaran",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 12),
        ...pendingBills.map((bill) => Card(
          color: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade200, width: 1),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.warning_amber_rounded, color: Colors.white),
            ),
            title: Text("Tagihan Klinik - Rp ${bill.totalBiaya}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Rincian: Jasa Dokter (Rp ${bill.biayaDokter}) + Obat (Rp ${bill.biayaObat})"),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PembayaranValidasiPage(pembayaran: bill),
                  ),
                );
              },
              child: const Text("Bayar Sekarang", style: TextStyle(color: Colors.white)),
            ),
          ),
        )).toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}
