import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Widget buildTextField(String hint, IconData icon, {bool obscure = false}) {
  return TextField(
    obscureText: obscure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.grey),
      hintText: hint,
      filled: true,
      fillColor: AppColors.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
