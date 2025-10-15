import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MaterialStorageCard extends StatelessWidget {
  final double usedStorage; // in bytes
  final double totalStorage; // in GB
  final int filesCount;

  const MaterialStorageCard({
    super.key,
    required this.usedStorage,
    required this.totalStorage,
    required this.filesCount,
  });

  // Convert size to human-readable string
  String _formatSize(double sizeInBytes) {
    if (sizeInBytes < 1024) return "${sizeInBytes.toStringAsFixed(0)} B";
    sizeInBytes /= 1024;
    if (sizeInBytes < 1024) return "${sizeInBytes.toStringAsFixed(1)} KB";
    sizeInBytes /= 1024;
    if (sizeInBytes < 1024) return "${sizeInBytes.toStringAsFixed(1)} MB";
    sizeInBytes /= 1024;
    return "${sizeInBytes.toStringAsFixed(2)} GB";
  }

  @override
  Widget build(BuildContext context) {
    // Convert totalStorage from GB to bytes for progress calculation
    final totalBytes = totalStorage * 1024 * 1024 * 1024;
    final progress = (usedStorage / totalBytes).clamp(0.0, 1.0);

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
          const Text(
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
                "${_formatSize(usedStorage)} of ${_formatSize(totalBytes)}",
                style: const TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$filesCount files",
                style: const TextStyle(
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
              valueColor: const AlwaysStoppedAnimation(AppColors.mintGreen),
            ),
          ),
        ],
      ),
    );
  }
}
