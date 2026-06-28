import 'package:flutter/material.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class DoctorCard extends StatelessWidget {
  final String nama;
  final String spesialis;
  final int pasienHariIni;
  final double rating;

  const DoctorCard({
    Key? key,
    required this.nama,
    required this.spesialis,
    required this.pasienHariIni,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 12),
          Text(nama, style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(spesialis, style: AppTextStyle.subtitle),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Pasien', style: AppTextStyle.subtitle),
                  Text('$pasienHariIni', style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  Text('Rating', style: AppTextStyle.subtitle),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 16),
                      Text(' $rating', style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
