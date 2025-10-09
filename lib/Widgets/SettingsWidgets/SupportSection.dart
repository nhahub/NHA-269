import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget buildSupportSection() {
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
    child: ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text('Help & Support'),
      subtitle: const Text('Get help and contact support'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    ),
  );
}

