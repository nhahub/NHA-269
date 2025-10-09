import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget buildAccountSection() {
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
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Profile'),
          subtitle: const Text('Manage your personal information'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to Profile page
          },
        ),
        const Divider(height: 0),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Privacy & Security'),
          subtitle: const Text('Control your privacy settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to Privacy page
          },
        ),
      ],
    ),
  );
}
