import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/core/responsive/responsive_layout.dart';
import 'package:poliklinik/providers/data_provider.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        children: [
          _buildChartContainer('Pasien per Bulan', const PatientBarChart()),
          const SizedBox(height: 24),
          _buildChartContainer('Dokter Aktif', const DoctorPieChart()),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildChartContainer('Pasien per Bulan', const PatientBarChart()),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _buildChartContainer('Dokter Aktif', const DoctorPieChart()),
        ),
      ],
    );
  }

  Widget _buildChartContainer(String title, Widget chart, {double height = 300}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.heading3),
          const SizedBox(height: 24),
          Expanded(child: chart),
        ],
      ),
    );
  }
}

class PatientBarChart extends StatelessWidget {
  const PatientBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patientsCount = context.watch<DataProvider>().patients.length;
    final int baseCount = patientsCount > 0 ? patientsCount : 10;

    // Scale chart dynamically
    final data = [
      {'label': 'Jan', 'val': (baseCount * 0.4).toInt()},
      {'label': 'Feb', 'val': (baseCount * 0.6).toInt()},
      {'label': 'Mar', 'val': (baseCount * 0.5).toInt()},
      {'label': 'Apr', 'val': (baseCount * 0.8).toInt()},
      {'label': 'Mei', 'val': (baseCount * 0.9).toInt()},
      {'label': 'Jun', 'val': baseCount},
    ];
    int maxVal = baseCount + 10;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.asMap().entries.map((entry) {
          final d = entry.value;
          final int index = entry.key;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${d['val']}', style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  width: 30,
                  height: 150.0 * (d['val'] as int) / maxVal,
                  decoration: BoxDecoration(
                    color: index == data.length - 1 ? AppColors.primary : AppColors.primary.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(d['label'] as String, style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DoctorPieChart extends StatelessWidget {
  const DoctorPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctors = context.watch<DataProvider>().doctors;
    final int total = doctors.isEmpty ? 1 : doctors.length;

    int umumCount = doctors.where((d) => d.spesialis.toLowerCase().contains('umum')).length;
    int gigiCount = doctors.where((d) => d.spesialis.toLowerCase().contains('gigi')).length;
    int anakCount = doctors.where((d) => d.spesialis.toLowerCase().contains('anak')).length;
    int lainnyaCount = total - (umumCount + gigiCount + anakCount);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegend('Umum', (umumCount / total * 100).toInt(), AppColors.primary),
        const SizedBox(height: 12),
        _buildLegend('Gigi', (gigiCount / total * 100).toInt(), AppColors.secondary),
        const SizedBox(height: 12),
        _buildLegend('Anak', (anakCount / total * 100).toInt(), AppColors.success),
        const SizedBox(height: 12),
        _buildLegend('Lainnya', (lainnyaCount / total * 100).toInt(), AppColors.warning),
      ],
    );
  }

  Widget _buildLegend(String title, int percent, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
        Text('$percent%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
      ],
    );
  }
}
