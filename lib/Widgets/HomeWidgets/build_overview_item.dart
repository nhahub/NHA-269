import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildOverviewItem({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2), // very tight
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8), // smaller icon circle
          child: Icon(icon, color: color, size: 18), // smaller icon
        ),
        const SizedBox(width: 8), // reduced space
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 11, // smaller text
              ),
            ),
            const SizedBox(height: 1), // tiny gap
            Text(
              value,
              style: const TextStyle(
                color: AppColors.deepSapphire,
                fontSize: 13, // slightly smaller
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
