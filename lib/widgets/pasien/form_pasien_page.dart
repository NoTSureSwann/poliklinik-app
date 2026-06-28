import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/pasien.dart';

class FormPasienPage extends StatefulWidget {
  final Pasien? pasien;

  const FormPasienPage({super.key, this.pasien});

  @override
  State<FormPasienPage> createState() => _FormPasienPageState();
}

class _FormPasienPageState extends State<FormPasienPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  bool _hasFoto = false;

  @override
  void initState() {
    super.initState();
    if (widget.pasien != null) {
      _namaController.text = widget.pasien!.nama;
      _alamatController.text = widget.pasien!.alamat;
      _teleponController.text = widget.pasien!.telepon;
      _hasFoto = widget.pasien!.hasFoto;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<DataProvider>();
      
      Pasien newPasien = Pasien(
        id: widget.pasien?.id,
        nama: _namaController.text,
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        hasFoto: _hasFoto,
      );

      if (widget.pasien == null) {
        await controller.addPasien(newPasien);
      } else {
        await controller.updatePasien(newPasien);
      }

      if (mounted) {
        if (controller.errorMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal: ${controller.errorMessage}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pasien != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Pasien' : 'Tambah Pasien'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _teleponController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Telepon tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Simulasi Upload Foto'),
                    subtitle: Text(_hasFoto ? 'Foto Terunggah' : 'Belum ada foto'),
                    value: _hasFoto,
                    secondary: Icon(
                      _hasFoto ? Icons.check_circle : Icons.upload_file,
                      color: _hasFoto ? Colors.green : Colors.grey,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _hasFoto = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: controller.isLoading ? null : _saveData,
                      child: controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Simpan', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
