import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/utils/time_util.dart';

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({Key? key}) : super(key: key);

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
    
    for (var janji in appointments.take(2)) {
      final namaPasien = pasienMap[janji.pasienId] ?? janji.pasienId;
      activities.add({
        'title': 'Janji Temu Baru',
        'subtitle': '$namaPasien mendaftar ke Dokter ${janji.dokterId}',
        'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(minutes: 5))), // Mock real time
        'icon': Icons.calendar_today,
        'color': AppColors.primary,
      });
    }

    for (var rekam in rekamList.take(2)) {
      final namaPasien = pasienMap[rekam.pasienId] ?? rekam.pasienId;
      activities.add({
        'title': 'Rekam Medis: ${rekam.statusFlow}',
        'subtitle': 'Diagnosa $namaPasien: ${rekam.diagnosa}',
        'time': TimeUtil.timeAgo(DateTime.now().subtract(const Duration(minutes: 45))), // Mock real time
        'icon': Icons.description,
        'color': AppColors.warning,
      });
    }

    if (activities.isEmpty) {
      activities.add({
        'title': 'Tidak ada aktivitas',
        'subtitle': 'Belum ada data janji temu atau rekam medis',
        'time': '-',
        'icon': Icons.history,
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
                child: Text('Aktivitas Terbaru', style: AppTextStyle.heading3, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...activities.asMap().entries.map((entry) {
            final idx = entry.key;
            final data = entry.value;
            return _buildActivityItem(
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

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyle.body2),
              const SizedBox(height: 4),
              Text(time, style: AppTextStyle.subtitle),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
