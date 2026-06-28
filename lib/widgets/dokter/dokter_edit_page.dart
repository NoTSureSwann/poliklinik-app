import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/dokter.dart';

import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class DokterEditPage extends StatefulWidget {
  final Dokter dokter;

  const DokterEditPage({
    super.key,
    required this.dokter,
  });

  @override
  State<DokterEditPage> createState() => _DokterEditPageState();
}

class _DokterEditPageState extends State<DokterEditPage> {
  late TextEditingController nama;
  late TextEditingController spesialis;
  late TextEditingController str;
  late TextEditingController jadwal;

  @override
  void initState() {
    super.initState();

    nama = TextEditingController(
      text: widget.dokter.nama,
    );

    spesialis = TextEditingController(
      text: widget.dokter.spesialis,
    );

    str = TextEditingController(
      text: widget.dokter.str,
    );

    jadwal = TextEditingController(
      text: widget.dokter.jadwal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Dokter"),
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
              text: "UPDATE",
              onPressed: () async {
                await controller.updateDokter(
                  Dokter(
                    id: widget.dokter.id,
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
