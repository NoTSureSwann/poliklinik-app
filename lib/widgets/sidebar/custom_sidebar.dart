import 'package:flutter/material.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class CustomSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String role;

  const CustomSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text('CareHub', style: AppTextStyle.heading2.copyWith(color: AppColors.primary, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 48),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_canAccess(0)) _buildMenuItem(0, Icons.dashboard_outlined, 'Dashboard'),
                if (_canAccess(1)) _buildMenuItem(1, Icons.people_outline, 'Pasien'),
                if (_canAccess(2)) _buildMenuItem(2, Icons.medical_services_outlined, 'Dokter'),
                if (_canAccess(3)) _buildMenuItem(3, Icons.calendar_today_outlined, 'Janji Temu'),
                if (_canAccess(4)) _buildMenuItem(4, Icons.description_outlined, 'Rekam Medis'),
                if (_canAccess(5)) _buildMenuItem(5, Icons.local_pharmacy_outlined, 'Farmasi'),
                if (_canAccess(6)) _buildMenuItem(6, Icons.payment_outlined, 'Loket'),
                if (_canAccess(7)) _buildMenuItem(7, Icons.pie_chart_outline, 'Laporan'),
                if (_canAccess(8)) _buildMenuItem(8, Icons.domain_add_outlined, 'Kelola Poli'),
                const Divider(height: 40),
                if (_canAccess(9)) _buildMenuItem(9, Icons.settings_outlined, 'Pengaturan'),
                _buildMenuItem(10, Icons.logout_outlined, 'Logout', isDanger: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title, {bool isDanger = false}) {
    final isSelected = selectedIndex == index;
    final color = isDanger ? AppColors.danger : (isSelected ? AppColors.primary : AppColors.textSecondary);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.hover : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: AppTextStyle.body1.copyWith(
            color: color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () => onItemSelected(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: isDanger ? AppColors.danger.withOpacity(0.1) : AppColors.hover,
      ),
    );
  }

  bool _canAccess(int index) {
    final userRole = role.toLowerCase();
    if (userRole == 'admin') return true;

    switch (userRole) {
      case 'dokter':
        return [0, 1, 4, 9].contains(index);
      case 'pasien':
        return [0, 3, 9].contains(index);
      case 'loket admin':
      case 'loket':
        return [0, 1, 2, 3, 6, 9].contains(index);
      case 'farmasi':
        return [0, 5, 9].contains(index);
      default:
        return [0, 9].contains(index); // Default: Dashboard & Settings
    }
  }
}
