import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MaterialFilterBar extends StatelessWidget {
  final String selected;
  final Function(String) onFilterChanged;

  const MaterialFilterBar({
    super.key,
    required this.selected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Notes", "PDFs", "Videos", "Images"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selected == filter;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.oceanBlue : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.oceanBlue.withAlpha(80),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.deepSapphire,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
