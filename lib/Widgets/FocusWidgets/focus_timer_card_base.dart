import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FocusTimerCardBase extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final int totalMinutes;

  const FocusTimerCardBase({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.totalMinutes = 25,
  });

  @override
  State<FocusTimerCardBase> createState() => _FocusTimerCardBaseState();
}

class _FocusTimerCardBaseState extends State<FocusTimerCardBase> {
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.totalMinutes * 60;
  }

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            timer?.cancel();
            isRunning = false;
          }
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
      remainingSeconds = widget.totalMinutes * 60;
      isRunning = false;
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    return 1 - (remainingSeconds / (widget.totalMinutes * 60));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with transparent circle
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, size: 42, color: widget.color),
          ),
          const SizedBox(height: 18),

          // Circular timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation(widget.color),
                ),
              ),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepSapphire,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Status
          Text(
            isRunning ? "${widget.title} Running..." : "${widget.title} Paused",
            style: const TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 18),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay, color: AppColors.deepSapphire),
                iconSize: 28,
                onPressed: resetTimer,
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: widget.color,
                  padding: const EdgeInsets.all(16),
                  elevation: 2,
                  shadowColor: widget.color.withAlpha(80),
                ),
                onPressed: toggleTimer,
                child: Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.alarm, color: AppColors.deepSapphire),
                iconSize: 28,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
