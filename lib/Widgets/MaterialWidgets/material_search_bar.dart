import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MaterialSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const MaterialSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // subtle shadow
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search materials...",
          prefixIcon: const Icon(Icons.search, color: AppColors.deepSapphire),
          filled: true,
          fillColor: Colors.transparent, // already handled by Container
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: AppColors.deepSapphire),
      ),
    );
  }
}
