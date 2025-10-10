import 'package:flutter/material.dart';
import 'focus_timer_card_base.dart';
import '../../theme/app_colors.dart';

class LongBreakTimerCard extends StatelessWidget {
  const LongBreakTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusTimerCardBase(
      title: "Long Break",
      color: AppColors.mintGreen,
      icon: Icons.airline_seat_recline_extra, // or any icon you prefer
      totalMinutes: 15,
    );
  }
}
