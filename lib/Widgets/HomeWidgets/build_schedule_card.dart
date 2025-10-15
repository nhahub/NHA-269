import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildScheduleCard({
  required String subject,
  required String time,
  required Color color,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // compact padding
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border(left: BorderSide(color: color, width: 5)), // thinner left border
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03), // lighter shadow
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subject,
              style: const TextStyle(
                color: AppColors.deepSapphire,
                fontSize: 14, // smaller, consistent with other tiles
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2), // tighter spacing
            Text(
              time,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12, // smaller, consistent
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
