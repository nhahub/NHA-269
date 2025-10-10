import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildTextField(
    String hint,
    IconData icon, {
      bool obscure = false,
      required TextEditingController controller,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.lightGrey.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: TextField(
      controller: controller, // ✅ عشان نمسك النص
      obscureText: obscure,
      cursorColor: AppColors.oceanBlue,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.deepSapphire, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.oceanBlue,
            width: 1.5,
          ),
        ),
      ),
    ),
  );
}
