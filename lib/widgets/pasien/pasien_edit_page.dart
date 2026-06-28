import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/pasien.dart';

import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class PasienEditPage extends StatefulWidget {
  final Pasien pasien;

  const PasienEditPage({
    super.key,
    required this.pasien,
  });

  @override
  State<PasienEditPage> createState() => _PasienEditPageState();
}

class _PasienEditPageState extends State<PasienEditPage> {
  late TextEditingController nama;

  late TextEditingController alamat;

  late TextEditingController telepon;

  @override
  void initState() {
    super.initState();

    nama = TextEditingController(
      text: widget.pasien.nama,
    );

    alamat = TextEditingController(
      text: widget.pasien.alamat,
    );

    telepon = TextEditingController(
      text: widget.pasien.telepon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pasien"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: nama,
              label: "Nama",
            ),
            CustomTextField(
              controller: alamat,
              label: "Alamat",
            ),
            CustomTextField(
              controller: telepon,
              label: "Telepon",
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "UPDATE",
              onPressed: () async {
                await controller.updatePasien(
                  Pasien(
                    id: widget.pasien.id,
                    nama: nama.text,
                    alamat: alamat.text,
                    telepon: telepon.text,
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
