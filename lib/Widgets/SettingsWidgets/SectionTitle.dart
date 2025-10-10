import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 4, top: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.deepSapphire,
      ),
    ),
  );
}
