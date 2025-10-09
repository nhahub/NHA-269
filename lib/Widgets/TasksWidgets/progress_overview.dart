import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.mintGreen),
              const SizedBox(width: 8),
              const Text(
                "Progress Overview",
                style: TextStyle(color: AppColors.deepSapphire, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "Completion Rate",
                style: TextStyle(color: AppColors.grey),
              ),
              const Spacer(),
              Text(
                "2/6",
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 2 / 6,
              backgroundColor: AppColors.oceanBlue.withOpacity(0.2),
              color: AppColors.oceanBlue,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox(
                  "4", "Pending", AppColors.oceanBlue, AppColors.oceanBlue),
              _buildStatBox(
                  "2", "Completed", AppColors.mintGreen, AppColors.mintGreen),
              _buildStatBox("2", "Overdue", Colors.redAccent, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String number, String label, Color color,
      Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
