import 'package:flutter/material.dart';

import 'package:poliklinik/models/rekam_medis.dart';

class RekamDetailPage extends StatelessWidget {
  final RekamMedis rekam;

  const RekamDetailPage({
    super.key,
    required this.rekam,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rekam"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Keluhan : ${rekam.keluhan}",
            ),
            const SizedBox(height: 10),
            Text(
              "Diagnosa : ${rekam.diagnosa}",
            ),
            const SizedBox(height: 10),
            Text(
              "Tindakan : ${rekam.tindakan}",
            ),
            const SizedBox(height: 10),
            Text(
              "Obat : ${rekam.obat}",
            ),
            const SizedBox(height: 10),
            Text(
              "Catatan : ${rekam.catatanDokter}",
            ),
            const SizedBox(height: 10),
            Text(
              "Tanggal : ${rekam.tanggal}",
            ),
          ],
        ),
      ),
    );
  }
}
