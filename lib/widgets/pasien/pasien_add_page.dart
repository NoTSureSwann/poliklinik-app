import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/pasien.dart';

import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class PasienAddPage extends StatefulWidget {
  const PasienAddPage({super.key});

  @override
  State<PasienAddPage> createState() => _PasienAddPageState();
}

class _PasienAddPageState extends State<PasienAddPage> {
  final namaController = TextEditingController();

  final alamatController = TextEditingController();

  final teleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pasien"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: namaController,
              label: "Nama",
            ),
            CustomTextField(
              controller: alamatController,
              label: "Alamat",
            ),
            CustomTextField(
              controller: teleponController,
              label: "Telepon",
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "SIMPAN",
              onPressed: () async {
                await controller.addPasien(
                  Pasien(
                    nama: namaController.text,
                    alamat: alamatController.text,
                    telepon: teleponController.text,
                  ),
                );

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
