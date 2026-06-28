import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/core/responsive/responsive_layout.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(24.0),
      child: ResponsiveLayout(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFooterContent(context),
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFooterContent(context),
        ),
      ),
    );
  }

  List<Widget> _buildFooterContent(BuildContext context) {
    final isDesktop = context.isDesktop;
    return [
      isDesktop
          ? Expanded(child: _buildLeftFooter())
          : _buildLeftFooter(),
      if (isDesktop) const SizedBox(width: 48),
      isDesktop
          ? Expanded(child: _buildRightFooter(context))
          : _buildRightFooter(context),
    ];
  }

  Widget _buildLeftFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        const SizedBox(height: 16),
        Text(
          'Klinik CareHub memberikan pelayanan kesehatan terbaik untuk Anda dan keluarga. Hubungi kami untuk informasi lebih lanjut atau jadwalkan janji temu hari ini.',
          style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Text('Contact Us', style: AppTextStyle.heading3),
        const SizedBox(height: 12),
        _buildContactItem(Icons.location_on, 'Jl. Kesehatan No. 123, Jakarta Selatan'),
        _buildContactItem(Icons.phone, '+62 21 1234 5678'),
        _buildContactItem(Icons.email, 'info@medilab.co.id'),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRightFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi Kami', style: AppTextStyle.heading3),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-6.200000, 106.816666), // Jakarta
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.poliklinik',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(-6.200000, 106.816666),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_pin,
                      color: Theme.of(context).colorScheme.error,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
