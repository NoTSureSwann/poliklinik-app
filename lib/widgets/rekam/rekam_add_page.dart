
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/rekam_medis.dart';
import 'package:poliklinik/models/janji_temu.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';
import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class RekamAddPage extends StatefulWidget {
  const RekamAddPage({Key? key}) : super(key: key);

  @override
  State<RekamAddPage> createState() => _RekamAddPageState();
}

class _RekamAddPageState extends State<RekamAddPage> {
  final pasienId = TextEditingController();
  final dokterId = TextEditingController();
  final keluhan = TextEditingController();
  final diagnosa = TextEditingController();
  final tindakan = TextEditingController();
  final obat = TextEditingController();
  final catatan = TextEditingController();
  final tanggal = TextEditingController();

  JanjiTemu? selectedJanji;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchAppointments();
      final now = DateTime.now();
      tanggal.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();
    final janjiController = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Rekam & Validasi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Pilih Janji Temu Pasien", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<JanjiTemu>(
              decoration: const InputDecoration(labelText: "Pilih Janji (Otomatis isi data)", border: OutlineInputBorder()),
              value: selectedJanji,
              items: janjiController.appointments.map((janji) {
                return DropdownMenuItem(
                  value: janji,
                  child: Text("Janji: ${janji.id} | Pasien: ${janji.pasienId} | Keluhan: ${janji.gejala ?? '-'}"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedJanji = val;
                  if (val != null) {
                    pasienId.text = val.pasienId;
                    dokterId.text = val.dokterId;
                    keluhan.text = val.gejala ?? '';
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: pasienId,
              label: "ID Pasien",
            ),
            CustomTextField(
              controller: dokterId,
              label: "ID Dokter",
            ),
            CustomTextField(
              controller: keluhan,
              label: "Validasi Gejala / Keluhan",
            ),
            CustomTextField(
              controller: diagnosa,
              label: "Diagnosa",
            ),
            CustomTextField(
              controller: tindakan,
              label: "Tindakan",
            ),
            CustomTextField(
              controller: obat,
              label: "Validasi / Resep Obat",
            ),
            CustomTextField(
              controller: catatan,
              label: "Catatan Dokter",
            ),
            CustomTextField(
              controller: tanggal,
              label: "Tanggal",
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "SIMPAN REKAM MEDIS",
              onPressed: () async {
                final janjiController = context.read<DataProvider>();
                await controller.addRekam(
                  RekamMedis(
                    pasienId: pasienId.text,
                    dokterId: dokterId.text,
                    keluhan: keluhan.text,
                    diagnosa: diagnosa.text,
                    tindakan: tindakan.text,
                    obat: obat.text,
                    catatanDokter: catatan.text,
                    tanggal: tanggal.text,
                    statusFlow: 'Menunggu Farmasi',
                  ),
                );
                
                // Jika dari JanjiTemu, update status janjinya
                if (selectedJanji != null) {
                  selectedJanji!.status = "Selesai Diagnosa";
                  await janjiController.updateJanji(selectedJanji!);
                }
                
                eventBus.publish(AppEvent('DiagnosaSelesai', pasienId.text));

                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
