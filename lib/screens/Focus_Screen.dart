import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/focus_service.dart';
import '../theme/app_colors.dart';
import '../Widgets/FocusWidgets/focus_mode_selector.dart';
import '../Widgets/FocusWidgets/focus_progress_card.dart';
import '../Widgets/FocusWidgets/timer_control_card.dart';
import '../Widgets/FocusWidgets/focus_history_chart.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final FocusService _focusService = FocusService();

  int selectedIndex = 0; // 0: Focus, 1: Short Break, 2: Long Break
  Timer? _timer;
  int _remainingSeconds = 25 * 60;
  int _initialSeconds = 25 * 60;
  bool _isRunning = false;

  // Configuration for each mode
  final Map<int, dynamic> _modeConfig = {
    0: {
      'seconds': 25 * 60,
      'title': 'Focus',
      'color': AppColors.oceanBlue,
      'icon': Icons.timer,
    },
    1: {
      'seconds': 5 * 60,
      'title': 'Short Break',
      'color': AppColors.teal,
      'icon': Icons.coffee,
    },
    2: {
      'seconds': 15 * 60,
      'title': 'Long Break',
      'color': AppColors.mintGreen,
      'icon': Icons.airline_seat_recline_extra,
    },
  };

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onModeChanged(int index) {
    setState(() {
      selectedIndex = index;
      _initialSeconds = _modeConfig[index]['seconds'];
      _resetTimer();
    });
  }

  // --- Timer Logic (Same as before) ---
  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _handleTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    _sendDataToFirebase(completed: true, duration: _initialSeconds);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Session Completed!")));
    _resetTimer();
  }

  void _resetWithoutSaving() {
    _timer?.cancel();
    _resetTimer();
  }

  void _stopAndSave() {
    _timer?.cancel();
    int elapsed = _initialSeconds - _remainingSeconds;
    if (elapsed > 0) {
      _sendDataToFirebase(completed: false, duration: elapsed);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Session Logged.")));
    }
    _resetTimer();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _remainingSeconds = _initialSeconds;
    });
  }

  Future<void> _sendDataToFirebase({
    required bool completed,
    required int duration,
  }) async {
    await _focusService.saveSession(
      type: _modeConfig[selectedIndex]['title'],
      durationSeconds: duration,
      completed: completed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract current theme data
    final currentConfig = _modeConfig[selectedIndex];
    final Color currentColor = currentConfig['color'];
    final String currentTitle = currentConfig['title'];
    final IconData currentIcon = currentConfig['icon'];

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
              style: TextStyle(color: AppColors.grey, fontSize: 14),
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

            // Replaced static cards with dynamic TimerControlCard
            TimerControlCard(
              title: currentTitle,
              icon: currentIcon,
              themeColor:
                  currentColor, // <--- Passes the color (Ocean/Teal/Mint)
              seconds: _remainingSeconds,
              isRunning: _isRunning,
              onPlayPause: _isRunning ? _pauseTimer : _startTimer,
              onReset: _resetWithoutSaving,
              onStop: _stopAndSave,
            ),

            const SizedBox(height: 20),
            FocusProgressCard(focusService: _focusService),

            const SizedBox(height: 20),
            FocusHistoryChart(focusService: _focusService),
          ],
        ),
      ),
    );
  }
}
