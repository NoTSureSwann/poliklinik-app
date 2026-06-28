import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';

class GlobalSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Cari pasien atau dokter...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Ketikkan nama untuk mencari...'));
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final pasienCtrl = context.read<DataProvider>();
    final dokterCtrl = context.read<DataProvider>();

    final pasienResults = pasienCtrl.patients.where(
        (p) => p.nama.toLowerCase().contains(query.toLowerCase())).toList();
    final dokterResults = dokterCtrl.doctors.where(
        (d) => d.nama.toLowerCase().contains(query.toLowerCase())).toList();

    if (pasienResults.isEmpty && dokterResults.isEmpty) {
      return const Center(child: Text('Tidak ada hasil ditemukan.'));
    }

    return ListView(
      children: [
        if (pasienResults.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Pasien', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          ...pasienResults.map((p) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: Text(p.nama),
                subtitle: Text('Telp: ${p.telepon}'),
                onTap: () {
                  // close(context, p);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Memilih Pasien: ${p.nama}')));
                },
              )),
        ],
        if (dokterResults.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Dokter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ),
          ...dokterResults.map((d) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.medical_services, color: Colors.green),
                ),
                title: Text(d.nama),
                subtitle: Text('Spesialis: ${d.spesialis}'),
                onTap: () {
                  // close(context, d);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Memilih Dokter: ${d.nama}')));
                },
              )),
        ],
      ],
    );
  }
}
