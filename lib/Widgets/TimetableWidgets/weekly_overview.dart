import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class WeeklyOverview extends StatelessWidget {
  final double totalHours;
  final int totalClasses;

  const WeeklyOverview({
    super.key,
    required this.totalHours,
    required this.totalClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOverviewItem(
            totalHours.toStringAsFixed(1),
            'Total Hours',
            AppColors.teal.withAlpha((0.1 * 255).round()),
          ),
          _buildOverviewItem(
            totalClasses.toString(),
            'Classes',
            AppColors.oceanBlue.withAlpha((0.1 * 255).round()),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String number, String label, Color bgColor) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.deepSapphire,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}