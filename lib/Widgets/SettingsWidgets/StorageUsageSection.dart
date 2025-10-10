import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildStorageUsageSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Storage Usage',
          style: TextStyle(
            color: AppColors.deepSapphire,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),

        // Progress bar and text
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 156.8 / 2048,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  color: Colors.green.shade600,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '156.8 MB of 2 GB',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Breakdown text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _StorageStat(label: 'Documents', value: '45.2 MB'),
            _StorageStat(label: 'Media', value: '89.1 MB'),
            _StorageStat(label: 'Cache', value: '22.5 MB'),
          ],
        ),
      ],
    ),
  );
}

class _StorageStat extends StatelessWidget {
  final String label;
  final String value;

  const _StorageStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.deepSapphire,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
