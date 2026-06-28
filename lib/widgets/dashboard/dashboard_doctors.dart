import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/widgets/cards/doctor_card.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';

class DashboardDoctors extends StatelessWidget {
  const DashboardDoctors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctors = context.watch<DataProvider>().doctors.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dokter Aktif Hari Ini', style: AppTextStyle.heading3),
        const SizedBox(height: 16),
        if (doctors.isEmpty)
          const Text('Belum ada dokter aktif hari ini.', style: TextStyle(color: Colors.grey))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: doctors.map((dokter) => DoctorCard(
                nama: dokter.nama,
                spesialis: dokter.spesialis,
                pasienHariIni: 0, // Mock for now, could be calculated
                rating: 5.0, // Mock for now
              )).toList(),
            ),
          ),
      ],
    );
  }
}
