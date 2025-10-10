import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildAboutSection() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/app_icon.png',
          width: 55,
          height: 55,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),
        const Text(
          'LearnFlow',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.deepSapphire,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Version 0.1',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.oceanBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.oceanBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
