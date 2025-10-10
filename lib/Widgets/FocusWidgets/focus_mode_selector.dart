import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FocusModeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onModeChanged;

  const FocusModeSelector({
    super.key,
    required this.selectedIndex,
    required this.onModeChanged,
  });

  final List<String> modes = const ["Focus", "Short Break", "Long Break"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(modes.length, (index) {
            final bool isSelected = selectedIndex == index;
            Color bgColor;
            switch (index) {
              case 0:
                bgColor = AppColors.oceanBlue;
                break;
              case 1:
                bgColor = AppColors.teal;
                break;
              case 2:
                bgColor = AppColors.mintGreen;
                break;
              default:
                bgColor = AppColors.oceanBlue;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onModeChanged(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? bgColor : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: bgColor.withAlpha(80),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    modes[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.deepSapphire,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
