import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/core/responsive/responsive_layout.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/widgets/cards/statistic_card.dart';
import 'package:poliklinik/providers/data_provider.dart';

class DashboardStatistics extends StatelessWidget {
  const DashboardStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPasien = context.watch<DataProvider>().patients.length;
    final totalDokter = context.watch<DataProvider>().doctors.length;
    final janjiTemu = context.watch<DataProvider>().appointments.length;
    final rekamMedis = context.watch<DataProvider>().rekamList.length;

    if (context.isMobile) {
      return Column(
        children: [
          StatisticCard(title: 'Total Pasien', count: '$totalPasien', icon: Icons.people, growth: '+12%', color: AppColors.primary),
          const SizedBox(height: 16),
          StatisticCard(title: 'Total Dokter', count: '$totalDokter', icon: Icons.medical_services, growth: '+5%', color: AppColors.secondary),
          const SizedBox(height: 16),
          StatisticCard(title: 'Janji Temu', count: '$janjiTemu', icon: Icons.calendar_today, growth: '+8%', color: AppColors.success),
          const SizedBox(height: 16),
          StatisticCard(title: 'Rekam Medis', count: '$rekamMedis', icon: Icons.description, growth: '+15%', color: AppColors.warning),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: StatisticCard(title: 'Total Pasien', count: '$totalPasien', icon: Icons.people, growth: '+12%', color: AppColors.primary)),
        const SizedBox(width: 24),
        Expanded(child: StatisticCard(title: 'Total Dokter', count: '$totalDokter', icon: Icons.medical_services, growth: '+5%', color: AppColors.secondary)),
        const SizedBox(width: 24),
        Expanded(child: StatisticCard(title: 'Janji Temu', count: '$janjiTemu', icon: Icons.calendar_today, growth: '+8%', color: AppColors.success)),
        const SizedBox(width: 24),
        Expanded(child: StatisticCard(title: 'Rekam Medis', count: '$rekamMedis', icon: Icons.description, growth: '+15%', color: AppColors.warning)),
      ],
    );
  }
}
