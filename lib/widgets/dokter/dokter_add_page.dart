import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/dokter.dart';

import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class DokterAddPage extends StatefulWidget {
  const DokterAddPage({super.key});

  @override
  State<DokterAddPage> createState() => _DokterAddPageState();
}

class _DokterAddPageState extends State<DokterAddPage> {
  final nama = TextEditingController();
  final spesialis = TextEditingController();
  final str = TextEditingController();
  final jadwal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Dokter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: nama,
              label: "Nama Dokter",
            ),
            CustomTextField(
              controller: spesialis,
              label: "Spesialis",
            ),
            CustomTextField(
              controller: str,
              label: "Nomor STR",
            ),
            CustomTextField(
              controller: jadwal,
              label: "Jadwal Praktik",
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "SIMPAN",
              onPressed: () async {
                await controller.addDokter(
                  Dokter(
                    nama: nama.text,
                    spesialis: spesialis.text,
                    str: str.text,
                    jadwal: jadwal.text,
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
