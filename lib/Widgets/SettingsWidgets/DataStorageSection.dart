import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget buildDataStorageSection() {
  return Container(
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
      children: [
        SwitchListTile(
          value: true,
          onChanged: (val) {},
          secondary: const Icon(Icons.cloud_outlined),
          title: const Text('Auto Backup'),
          subtitle: const Text('Automatically backup your data'),
        ),
        const Divider(height: 0),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Theme'),
          subtitle: const Text('Customize app appearance'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    ),
  );
}

