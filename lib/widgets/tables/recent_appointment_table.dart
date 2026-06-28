import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/widgets/states/empty_state_widget.dart';

class RecentAppointmentTable extends StatelessWidget {
  const RecentAppointmentTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointments = context.watch<DataProvider>().appointments.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Janji Temu Terbaru',
                  style: AppTextStyle.heading3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (appointments.isEmpty)
            const EmptyStateWidget(
              icon: Icons.event_busy,
              title: 'Tidak Ada Janji',
              message: 'Belum ada janji temu pasien yang masuk saat ini.',
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: AppTextStyle.subtitle,
                dataTextStyle: AppTextStyle.body1,
                columns: const [
                  DataColumn(label: Text('Nama Pasien')),
                  DataColumn(label: Text('Dokter ID')),
                  DataColumn(label: Text('Waktu')),
                  DataColumn(label: Text('Status')),
                ],
                rows: appointments.map((janji) {
                  return _buildRow(
                    janji.pasienId,
                    janji.dokterId,
                    "${janji.tanggal} ${janji.jam}",
                    janji.status,
                    janji.status == 'Selesai' ? AppColors.success : 
                    janji.status == 'Diproses' ? AppColors.secondary : AppColors.warning,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  DataRow _buildRow(String pasien, String dokter, String tanggal, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(pasien, style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w500))),
        DataCell(Text(dokter)),
        DataCell(Text(tanggal)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: AppTextStyle.subtitle.copyWith(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
