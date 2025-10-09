import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';


Widget buildPreferencesSection() {
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
        SwitchListTile(
          value: false,
          onChanged: (val) {
            // Dark mode toggle
          },
          secondary: const Icon(Icons.brightness_6_outlined),
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch between light and dark theme'),
        ),

        const Divider(height: 0),

        SwitchListTile(
          value: true,
          onChanged: (val) {
            // Notifications toggle
          },
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text('Enable push notifications'),
        ),

        const Divider(height: 0),

        SwitchListTile(
          value: true,
          onChanged: (val) {
            // Sound effects toggle
          },
          secondary: const Icon(Icons.volume_up_outlined),
          title: const Text('Sound Effects'),
          subtitle: const Text('Play sounds for interactions'),
        ),

      ],
    ),
  );
}


