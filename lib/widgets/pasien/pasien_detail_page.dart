import 'package:flutter/material.dart';

import 'package:poliklinik/models/pasien.dart';

class PasienDetailPage extends StatelessWidget {
  final Pasien pasien;

  const PasienDetailPage({
    super.key,
    required this.pasien,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pasien"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama : ${pasien.nama}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Alamat : ${pasien.alamat}",
            ),
            const SizedBox(height: 10),
            Text(
              "Telepon : ${pasien.telepon}",
            ),
          ],
        ),
      ),
    );
  }
}
