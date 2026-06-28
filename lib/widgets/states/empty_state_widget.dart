import 'package:flutter/material.dart';
import 'package:poliklinik/theme/app_text_style.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine colors based on Theme mode if we set it up, but for now we use AppColors/Theme.
    final iconColor = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white24 
        : Colors.black12;
    
    final textColor = Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[400] 
        : Colors.grey[600];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyle.heading3.copyWith(color: textColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyle.body1.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
