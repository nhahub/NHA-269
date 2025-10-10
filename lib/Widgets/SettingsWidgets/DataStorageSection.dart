import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../Shared/compact_switch_tile.dart';

Widget buildDataStorageSection() {
  return Container(
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
      children: [
        CompactSwitchTile(
          value: true,
          onChanged: (val) {},
          icon: Icons.cloud_outlined,
          title: 'Auto Backup',
          subtitle: 'Automatically backup your data',
        ),
        const Divider(height: 0),

        // Theme tile matching AccountSection style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.palette_outlined,
                color: AppColors.deepSapphire,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Theme',
                      style: TextStyle(
                        color: AppColors.deepSapphire,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Customize app appearance',
                      style: TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grey),
            ],
          ),
        ),
      ],
    ),
  );
}
