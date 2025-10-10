import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MaterialItemCard extends StatelessWidget {
  final String title;
  final String subject;
  final String size;
  final String time;
  final Color color;
  final IconData icon;

  const MaterialItemCard({
    super.key,
    required this.title,
    required this.subject,
    required this.size,
    required this.time,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with colored circular background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          // Title and Subject
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.deepSapphire,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Size and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                size,
                style: const TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Download icon
          Icon(Icons.download_rounded, color: AppColors.oceanBlue),
        ],
      ),
    );
  }
}
