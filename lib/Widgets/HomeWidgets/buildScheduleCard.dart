import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget buildScheduleCard({
  required String subject,
  required String time,
  required Color color,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border(left: BorderSide(color: color, width: 6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(
                color: AppColors.deepSapphire,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );
}

