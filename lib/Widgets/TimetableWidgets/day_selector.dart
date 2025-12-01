import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final Function(int) onDaySelected;

  const DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onDaySelected(index),
          child: Container(
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.oceanBlue : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.deepSapphire,
                  ),
                ),
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white70 : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}