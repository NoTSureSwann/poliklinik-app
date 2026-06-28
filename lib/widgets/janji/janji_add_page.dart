import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/janji_temu.dart';
import 'package:poliklinik/models/dokter.dart';
import 'package:poliklinik/models/poli.dart';

import 'package:poliklinik/widgets/custom_button.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class JanjiAddPage extends StatefulWidget {
  const JanjiAddPage({super.key});

  @override
  State<JanjiAddPage> createState() => _JanjiAddPageState();
}

class _JanjiAddPageState extends State<JanjiAddPage> {
  final tanggal = TextEditingController();
  final jam = TextEditingController();
  final gejala = TextEditingController();

  Poli? selectedPoli;
  Dokter? selectedDokter;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchPolis();
      context.read<DataProvider>().fetchDoctors();
      // Set current date/time as default
      final now = DateTime.now();
      tanggal.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      jam.text = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();
    final poliController = context.watch<DataProvider>();
    final dokterController = context.watch<DataProvider>();
    final authController = context.read<AuthProvider>();
    
    final currentPasienId = authController.currentUser?.id ?? "pasien_unknown";

    // Filter dokter based on selected poli (spesialis maps to poli nama)
    List<Dokter> filteredDokters = [];
    if (selectedPoli != null) {
      filteredDokters = dokterController.doctors.where((d) => 
        d.spesialis.toLowerCase().contains(selectedPoli!.nama.toLowerCase().replaceAll("poli ", ""))
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Janji & Pembayaran"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("1. Keluhan Pasien", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: gejala,
              label: "Gejala / Keluhan",
            ),
            const SizedBox(height: 20),
            
            const Text("2. Pilih Poli & Dokter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Poli>(
              decoration: const InputDecoration(labelText: "Pilih Poli", border: OutlineInputBorder()),
              value: selectedPoli,
              items: poliController.polis.map((poli) {
                return DropdownMenuItem(
                  value: poli,
                  child: Text(poli.nama),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedPoli = val;
                  selectedDokter = null; // Reset doctor when poli changes
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Dokter>(
              decoration: const InputDecoration(labelText: "Pilih Dokter", border: OutlineInputBorder()),
              value: selectedDokter,
              items: filteredDokters.map((dokter) {
                return DropdownMenuItem(
                  value: dokter,
                  child: Text("${dokter.nama} - ${dokter.jadwal}"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedDokter = val;
                });
              },
            ),
            const SizedBox(height: 20),
            
            const Text("3. Waktu Kunjungan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: CustomTextField(controller: tanggal, label: "Tanggal (YYYY-MM-DD)")),
                const SizedBox(width: 16),
                Expanded(child: CustomTextField(controller: jam, label: "Jam (HH:MM)")),
              ],
            ),
            const SizedBox(height: 20),
            
            if (selectedDokter != null) ...[
              const Divider(),
              const Text("4. Pembayaran (Visual)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Biaya Jasa Dokter: ${_formatRupiah(selectedDokter!.biaya ?? 50000)}", 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: QrImageView(
                          data: 'PAY_${selectedDokter!.id}_${currentPasienId}_${selectedDokter!.biaya ?? 50000}',
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Scan QR Code di atas untuk membayar", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text("Simulasi: Saya sudah membayar"),
                        value: isPaid,
                        onChanged: (val) {
                          setState(() {
                            isPaid = val ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            CustomButton(
              text: "BUAT JANJI",
              onPressed: () async {
                if (selectedDokter == null || selectedPoli == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih Poli dan Dokter terlebih dahulu')));
                  return;
                }
                if (gejala.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gejala harus diisi')));
                  return;
                }

                await controller.addJanji(
                  JanjiTemu(
                    pasienId: currentPasienId,
                    dokterId: selectedDokter!.id ?? 'unknown',
                    tanggal: tanggal.text,
                    jam: jam.text,
                    status: isPaid ? "Menunggu Dokter" : "Belum Lunas",
                    gejala: gejala.text,
                    poliId: selectedPoli!.id,
                    biayaJasa: selectedDokter!.biaya ?? 50000,
                    isPaid: isPaid,
                  ),
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatRupiah(int number) {
    return "Rp " + number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
