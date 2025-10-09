import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildSignOutButton() {
  return GestureDetector(
    onTap: () {
      // Sign out logic
    },
    child: Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: 8),
          Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
