import 'dart:async';
import 'package:flutter/material.dart';
import '../Widgets/FocusWidgets/focus_mode_selector.dart';
import '../Widgets/FocusWidgets/focus_progress_card.dart';
import '../Widgets/FocusWidgets/focus_timer_card.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({Key? key}) : super(key: key);

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int elapsedSeconds = 0;
  bool isRunning = false;
  Timer? timer;

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          elapsedSeconds++;
        });
      });
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      elapsedSeconds = 0;
      isRunning = false;
    });
  }

  String get formattedTime {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Focus",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Pomodoro Timer",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const FocusModeSelector(),
            const SizedBox(height: 20),
            FocusTimerCard(
              timeText: formattedTime,
              isRunning: isRunning,
              onPlayPause: toggleTimer,
              onReset: resetTimer,
            ),
            const SizedBox(height: 24),
            const FocusProgressCard(),
          ],
        ),
      ),
    );
  }
}