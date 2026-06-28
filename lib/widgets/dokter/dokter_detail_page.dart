import 'package:flutter/material.dart';

import 'package:poliklinik/models/dokter.dart';

class DokterDetailPage extends StatelessWidget {
  final Dokter dokter;

  const DokterDetailPage({
    super.key,
    required this.dokter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Dokter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dokter.nama,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Spesialis : ${dokter.spesialis}",
            ),
            const SizedBox(height: 10),
            Text(
              "STR : ${dokter.str}",
            ),
            const SizedBox(height: 10),
            Text(
              "Jadwal : ${dokter.jadwal}",
            ),
          ],
        ),
      ),
    );
  }
}
