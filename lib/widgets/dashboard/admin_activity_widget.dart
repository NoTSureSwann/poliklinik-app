import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/utils/time_util.dart';

class AdminActivityMonitoringWidget extends StatelessWidget {
  const AdminActivityMonitoringWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointments = context.watch<DataProvider>().appointments;
    final rekamList = context.watch<DataProvider>().rekamList;
    final patients = context.watch<DataProvider>().patients;

    // Resolving N+1 Problem using Big O(1) HashMap approach for Patient Data Fallback
    final Map<String, String> pasienMap = {};
    for (var p in patients) {
      pasienMap[p.id ?? p.nama] = p.nama;
    }

    // Combine into a simple list of activities
    List<Map<String, dynamic>> activities = [];
    
    // Add Janji Temu activities (Pasien -> Loket/Dokter)
    for (var janji in appointments.take(3)) {
      final namaPasien = pasienMap[janji.pasienId] ?? janji.pasienId;
      activities.add({
        'role': 'Pasien/Loket',
        'title': 'Janji Temu Baru',
        'subtitle': '$namaPasien mendaftar ke Dokter ${janji.dokterId}',
        'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(minutes: 5))), // Mock real time
        'icon': Icons.calendar_today,
        'color': AppColors.primary,
      });
    }

    // Add Rekam Medis activities (Dokter)
    for (var rekam in rekamList.take(3)) {
      final namaPasien = pasienMap[rekam.pasienId] ?? rekam.pasienId;
      activities.add({
        'role': 'Dokter',
        'title': 'Pemeriksaan Selesai',
        'subtitle': 'Dr. memeriksa $namaPasien: ${rekam.diagnosa}',
        'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(minutes: 30))), // Mock real time
        'icon': Icons.medical_services,
        'color': AppColors.secondary,
      });
    }

    // Add mock Farmasi activities
    activities.add({
      'role': 'Farmasi',
      'title': 'Obat Disiapkan',
      'subtitle': 'Resep untuk Pasien John Doe telah disiapkan',
      'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(minutes: 45))),
      'icon': Icons.local_pharmacy,
      'color': AppColors.warning,
    });

    // Add mock Pembayaran activities
    activities.add({
      'role': 'Kasir',
      'title': 'Pembayaran Divalidasi',
      'subtitle': 'Pembayaran QRIS berhasil untuk AUTO-1782367959578',
      'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(hours: 1))),
      'icon': Icons.payment,
      'color': AppColors.success,
    });

    // Sort mock activities by "simulated" logic (here we just shuffle or leave as is)
    // In real app, you'd sort by an actual DateTime timestamp.

    if (activities.isEmpty) {
      activities.add({
        'role': 'System',
        'title': 'Tidak ada aktivitas',
        'subtitle': 'Sistem berjalan normal',
        'time': '-',
        'icon': Icons.check_circle_outline,
        'color': Colors.grey,
      });
    }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monitoring Aktivitas Proyek', style: AppTextStyle.heading3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Log seluruh aktivitas dari berbagai role', style: AppTextStyle.body2),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Live',
                  style: AppTextStyle.subtitle.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...activities.asMap().entries.map((entry) {
            final idx = entry.key;
            final data = entry.value;
            return _buildActivityItem(
              data['role'],
              data['title'],
              data['subtitle'],
              data['time'],
              data['icon'],
              data['color'],
              isLast: idx == activities.length - 1,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String role, String title, String subtitle, String time, IconData icon, Color color, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role,
                      style: AppTextStyle.subtitle.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(time, style: AppTextStyle.subtitle),
                ],
              ),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyle.body2),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
