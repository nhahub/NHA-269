import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget buildAboutSection() {
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
      children: [
        const Icon(Icons.person_outline, size: 40, color: Colors.blue),
        const SizedBox(height: 8),
        const Text('LearnFlow', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Text('Version 2.1.0', style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Privacy Policy', style: TextStyle(fontSize: 12, color: Colors.blue)),
            SizedBox(width: 12),
            Text('Terms of Service', style: TextStyle(fontSize: 12, color: Colors.blue)),
          ],
        )
      ],
    ),
  );
}