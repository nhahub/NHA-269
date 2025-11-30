// progress_overview.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProgressOverview extends StatelessWidget {
  final int pendingTasks;
  final int completedTasks;
  final int overdueTasks;

  const ProgressOverview({
    super.key,
    this.pendingTasks = 0,
    this.completedTasks = 0,
    this.overdueTasks = 0,
  });

  @override
  Widget build(BuildContext context) {
    final int totalTasks = pendingTasks + completedTasks + overdueTasks;
    final double completedPercent = totalTasks > 0
        ? completedTasks / totalTasks
        : 0.0;
    final double pendingPercent = totalTasks > 0
        ? pendingTasks / totalTasks
        : 0.0;
    final double overduePercent = totalTasks > 0
        ? overdueTasks / totalTasks
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepSapphire,
            ),
          ),
          const SizedBox(height: 16),
          // Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: totalTasks == 0
                  ? Container(color: Colors.grey.shade200)
                  : Row(
                      children: [
                        if (completedTasks > 0)
                          Expanded(
                            flex: (completedPercent * 100).toInt(),
                            child: Container(color: AppColors.deepSapphire),
                          ),
                        if (pendingTasks > 0)
                          Expanded(
                            flex: (pendingPercent * 100).toInt(),
                            child: Container(
                              color: AppColors.oceanBlue.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        if (overdueTasks > 0)
                          Expanded(
                            flex: (overduePercent * 100).toInt(),
                            child: Container(
                              color: Colors.red.withValues(alpha: 0.4),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'Completed',
                value: completedTasks.toString(),
                color: AppColors.deepSapphire,
              ),
              _StatItem(
                label: 'Pending',
                value: pendingTasks.toString(),
                color: AppColors.oceanBlue,
              ),
              _StatItem(
                label: 'Overdue',
                value: overdueTasks.toString(),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.grey)),
        ],
      ),
    );
  }
}
