import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/janji_temu.dart';

import 'package:poliklinik/widgets/custom_button.dart';

class JanjiEditPage extends StatefulWidget {
  final JanjiTemu janji;

  const JanjiEditPage({
    super.key,
    required this.janji,
  });

  @override
  State<JanjiEditPage> createState() => _JanjiEditPageState();
}

class _JanjiEditPageState extends State<JanjiEditPage> {
  late String status;

  @override
  void initState() {
    super.initState();

    status = widget.janji.status;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Janji"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: status,
              items: const [
                DropdownMenuItem(
                  value: "Menunggu",
                  child: Text("Menunggu"),
                ),
                DropdownMenuItem(
                  value: "Disetujui",
                  child: Text("Disetujui"),
                ),
                DropdownMenuItem(
                  value: "Selesai",
                  child: Text("Selesai"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "UPDATE",
              onPressed: () async {
                await controller.updateJanji(
                  JanjiTemu(
                    id: widget.janji.id,
                    pasienId: widget.janji.pasienId,
                    dokterId: widget.janji.dokterId,
                    tanggal: widget.janji.tanggal,
                    jam: widget.janji.jam,
                    status: status,
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
