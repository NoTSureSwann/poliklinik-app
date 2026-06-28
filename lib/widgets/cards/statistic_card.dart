import 'package:flutter/material.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class StatisticCard extends StatefulWidget {
  final String title;
  final String count;
  final IconData icon;
  final String growth;
  final Color color;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.growth,
    required this.color,
  }) : super(key: key);

  @override
  State<StatisticCard> createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic, // Using Bezier logic internally
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // 3D Perspective
          ..rotateX(isHovered ? 0.05 : 0.0) // Tilt down slightly
          ..translate(0.0, isHovered ? -5.0 : 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(isHovered ? 0.2 : 0.05),
              blurRadius: isHovered ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.growth,
                    style: AppTextStyle.subtitle.copyWith(color: AppColors.success),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.count, style: AppTextStyle.heading1),
            const SizedBox(height: 4),
            Text(widget.title, style: AppTextStyle.body2),
          ],
        ),
      ),
    );
  }
}
