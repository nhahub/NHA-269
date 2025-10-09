
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
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Used Storage',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: 156.8 / 2048, // تقريباً 2GB
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '156.8 MB of 2 GB',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('45.2 MB\nDocuments', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            Text('89.1 MB\nMedia', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            Text('22.5 MB\nCache', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}

