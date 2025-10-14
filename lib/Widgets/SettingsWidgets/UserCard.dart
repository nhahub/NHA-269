import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget buildUserCard() {
  final user = FirebaseAuth.instance.currentUser;

  String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'S';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }

  final initials = getInitials(user?.displayName);

  return Container(
    padding: const EdgeInsets.all(16),
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
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.oceanBlue,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'Student',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSapphire,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                user?.email ?? 'Student',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Student',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: AppColors.grey.withValues(alpha: 0.7),
          size: 22,
        ),
      ],
    ),
  );
}
