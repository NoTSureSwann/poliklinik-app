import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.currentUser?.name ?? 'Pengguna';
    final userRole = auth.currentUser?.role ?? '';
    final roleText = userRole.isNotEmpty ? '${userRole[0].toUpperCase()}${userRole.substring(1)}' : '';
    
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Halo $userName 👋',
                  style: AppTextStyle.heading1.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ),
              GestureDetector(
                onTap: () => _showLiveProfile(context, auth.currentUser!),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
          if (roleText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                roleText,
                style: AppTextStyle.body2.copyWith(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Selamat Datang di Sistem Informasi Poliklinik',
            style: AppTextStyle.body1.copyWith(color: colorScheme.onPrimaryContainer.withOpacity(0.8)),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              _buildHighlight(context, 'Total Pasien', '1,245'),
              _buildHighlight(context, 'Janji Hari Ini', '45'),
              _buildHighlight(context, 'Rekam Medis Baru', '12'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlight(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyle.heading2.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        Text(label, style: AppTextStyle.body2.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7))),
      ],
    );
  }

  void _showLiveProfile(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: const Text('Profil Pengguna', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(Icons.person, size: 60, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text(user.name, style: AppTextStyle.heading2),
              Text(user.email, style: AppTextStyle.body2.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),
              _buildProfileRow(context, Icons.phone, 'Telepon', user.phone.isNotEmpty ? user.phone : '-'),
              const SizedBox(height: 16),
              _buildProfileRow(context, Icons.wc, 'Jenis Kelamin', user.gender.isNotEmpty ? user.gender : '-'),
              const SizedBox(height: 16),
              _buildProfileRow(context, Icons.admin_panel_settings, 'Hak Akses (Role)', user.role.toUpperCase()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.errorContainer, foregroundColor: colorScheme.onErrorContainer),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 24, color: colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
