import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../Shared/compact_switch_tile.dart';

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
        CompactSwitchTile(
          value: false,
          onChanged: (val) {}, 
          icon: Icons.brightness_6_outlined,
          title: 'Dark Mode',
          subtitle: 'Switch between light and dark theme',
        ),
        const Divider(height: 0),
        CompactSwitchTile(
          value: true,
          onChanged: (val) {}, 
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Enable push notifications',
        ),
        const Divider(height: 0),
        CompactSwitchTile(
          value: true,
          onChanged: (val) {}, 
          icon: Icons.volume_up_outlined,
          title: 'Sound Effects',
          subtitle: 'Play sounds for interactions',
        ),
      ],
    ),
  );
}
