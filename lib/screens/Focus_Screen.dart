import 'package:flutter/material.dart';
import '../Widgets/FocusWidgets/focus_mode_selector.dart';
import '../Widgets/FocusWidgets/focus_progress_card.dart';
import '../Widgets/FocusWidgets/focus_timer_card.dart';
import '../Widgets/FocusWidgets/short_break_timer_card.dart';
import '../Widgets/FocusWidgets/long_break_timer_card.dart';
import '../theme/app_colors.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int selectedIndex = 0; // 0: Focus, 1: Short Break, 2: Long Break

  void onModeChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentTimer;
    switch (selectedIndex) {
      case 0:
        currentTimer = const FocusTimerCard();
        break;
      case 1:
        currentTimer = const ShortBreakTimerCard();
        break;
      case 2:
        currentTimer = const LongBreakTimerCard();
        break;
      default:
        currentTimer = const FocusTimerCard();
    }

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightGrey,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Focus",
              style: TextStyle(
                color: AppColors.deepSapphire,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Pomodoro Timer",
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            color: AppColors.deepSapphire,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            FocusModeSelector(
              selectedIndex: selectedIndex,
              onModeChanged: onModeChanged,
            ),
            const SizedBox(height: 20),
            currentTimer,
            const SizedBox(height: 20),
            const FocusProgressCard(),
          ],
        ),
      ),
    );
  }
}
