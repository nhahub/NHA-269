import 'package:flutter/material.dart';
import 'focus_timer_card_base.dart';
import '../../theme/app_colors.dart';

class FocusTimerCard extends StatelessWidget {
  const FocusTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusTimerCardBase(
      title: "Focus Time",
      color: AppColors.oceanBlue,
      icon: Icons.center_focus_strong,
      totalMinutes: 25,
    );
  }
}
