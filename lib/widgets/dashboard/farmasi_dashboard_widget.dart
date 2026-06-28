import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class FarmasiDashboardWidget extends StatefulWidget {
  const FarmasiDashboardWidget({Key? key}) : super(key: key);

  @override
  State<FarmasiDashboardWidget> createState() => _FarmasiDashboardWidgetState();
}

class _FarmasiDashboardWidgetState extends State<FarmasiDashboardWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<DataProvider>().fetchObat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.currentUser?.role != 'farmasi') return const SizedBox.shrink();

    final obatCtrl = context.watch<DataProvider>();
    final lowStockObat = obatCtrl.obatList.where((o) => o.stok < 20).toList();

    if (lowStockObat.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              "Peringatan Stok Obat Menipis",
              style: AppTextStyle.heading3.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...lowStockObat.map((obat) => Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.orange.shade200, width: 1),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.medication, color: Colors.white),
                ),
                title: Text(obat.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Kategori: ${obat.kategori}"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Sisa: ${obat.stok}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 24),
      ],
    );
  }
}
