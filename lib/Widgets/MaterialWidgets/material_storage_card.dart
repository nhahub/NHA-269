import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MaterialStorageCard extends StatelessWidget {
  final String usedStorage;
  final String totalStorage;
  final int filesCount;
  final double progress;

  const MaterialStorageCard({
    super.key,
    required this.usedStorage,
    required this.totalStorage,
    required this.filesCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Storage Used",
            style: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$usedStorage of $totalStorage",
                style: const TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$filesCount files",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation(AppColors.mintGreen),
            ),
          ),
        ],
      ),
    );
  }
}
