import 'package:flutter/material.dart';
import 'focus_timer_card_base.dart';
import '../../theme/app_colors.dart';

class ShortBreakTimerCard extends StatelessWidget {
  const ShortBreakTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusTimerCardBase(
      title: "Short Break",
      color: AppColors.teal,
      icon: Icons.free_breakfast, // or any icon you prefer
      totalMinutes: 5,
    );
  }
}
