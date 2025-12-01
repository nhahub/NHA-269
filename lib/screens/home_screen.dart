import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/focus_service.dart';
import '../Widgets/HomeWidgets/build_feature_card.dart';
import '../Widgets/HomeWidgets/build_overview_item.dart';
import '../Widgets/HomeWidgets/build_schedule_card.dart';
import '../theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../FireBase/task_service.dart';
import '../FireBase/timetable_service.dart';// Import Focus Service

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TimetableService _timetableService = TimetableService();
  final FocusService _focusService = FocusService(); // Initialize Focus Service

  bool _isLoading = true;
  int _pendingTasks = 0;
  int _streakDays = 0; // Variable to store streak
  String _nextClass = 'No classes today';
  String _nextClassTime = '';
  List<Map<String, dynamic>> _todaySchedule = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      // 1. Get pending tasks count
      final pendingCount = await _taskService.getPendingTasksCount();

      // 2. Get Study Streak from Focus Service
      final streak = await _focusService.getStudyStreak();

      // 3. Get today's schedule
      final now = DateTime.now();
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final today = dayNames[now.weekday - 1];

      final todayEntries = await _timetableService.getEntriesForDay(today);

      // Sort by start time
      todayEntries.sort((a, b) => a['startTime'].compareTo(b['startTime']));

      // Find next class
      String nextClass = 'No classes today';
      String nextClassTime = '';

      for (var entry in todayEntries) {
        final startTime = _parseTime(entry['startTime']);
        if (startTime != null && startTime.isAfter(now)) {
          nextClass = entry['subject'];
          nextClassTime = entry['startTime'];
          break;
        }
      }

      setState(() {
        _pendingTasks = pendingCount;
        _streakDays = streak; // Update state
        _nextClass = nextClass;
        _nextClassTime = nextClassTime;
        _todaySchedule = todayEntries.take(3).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dashboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  String _formatTime12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightGrey,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepSapphire,
                  ),
                  children: [
                    const TextSpan(text: 'Welcome back, '),
                    TextSpan(
                      text:
                          '${(user?.displayName?.split(' ').first ?? 'Student')}!',
                      style: const TextStyle(color: AppColors.oceanBlue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ready to learn something new?',
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: const Icon(Icons.notifications_none),
            color: AppColors.deepSapphire,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.person),
            color: AppColors.deepSapphire,
          ),
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
            color: AppColors.deepSapphire,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.oceanBlue),
            )
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: AppColors.oceanBlue,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Overview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Overview',
                              style: TextStyle(
                                color: AppColors.deepSapphire,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildOverviewItem(
                              icon: Icons.timer,
                              label: 'Next Class',
                              value: _nextClassTime.isEmpty
                                  ? _nextClass
                                  : '$_nextClass - ${_formatTime12Hour(_nextClassTime)}',
                              color: AppColors.teal,
                            ),
                            const SizedBox(height: 12),
                            buildOverviewItem(
                              icon: Icons.task,
                              label: 'Pending Tasks',
                              value: _pendingTasks == 0
                                  ? 'All caught up!'
                                  : '$_pendingTasks ${_pendingTasks == 1 ? 'task' : 'tasks'}',
                              color: AppColors.oceanBlue,
                            ),
                            const SizedBox(height: 12),

                            // UPDATED STREAK ITEM
                            buildOverviewItem(
                              icon: Icons
                                  .local_fire_department, // Changed icon to fire for streak
                              label: 'Study Streak',
                              value: '$_streakDays days',
                              color: AppColors.mintGreen,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Main Features
                      const Text(
                        'Main Features',
                        style: TextStyle(
                          color: AppColors.deepSapphire,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          buildFeatureCard(
                            icon: Icons.calendar_month,
                            title: 'Timetable',
                            subtitle: 'Manage your schedule',
                            color: AppColors.oceanBlue,
                            onTap: () {
                              Navigator.pushNamed(context, '/timetable');
                            },
                          ),
                          buildFeatureCard(
                            icon: Icons.menu_book_rounded,
                            title: 'Materials',
                            subtitle: 'Access study resources',
                            color: AppColors.teal,
                            onTap: () {
                              Navigator.pushNamed(context, '/Material');
                            },
                          ),
                          buildFeatureCard(
                            icon: Icons.check_circle_outline,
                            title: 'Tasks',
                            subtitle: 'Track assignments',
                            color: AppColors.mintGreen,
                            onTap: () {
                              Navigator.pushNamed(context, '/tasks');
                            },
                          ),
                          buildFeatureCard(
                            icon: Icons.center_focus_strong,
                            title: 'Focus',
                            subtitle: 'Pomodoro timer',
                            color: AppColors.deepSapphire,
                            onTap: () {
                              Navigator.pushNamed(context, '/Focus');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Today's Schedule
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Today's Schedule",
                                  style: TextStyle(
                                    color: AppColors.deepSapphire,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/timetable');
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: AppColors.oceanBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _todaySchedule.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_busy,
                                          size: 48,
                                          color: AppColors.grey.withOpacity(
                                            0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'No classes scheduled for today',
                                          style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: _todaySchedule.map((entry) {
                                      final color = Color(
                                        int.parse(entry['color']),
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: buildScheduleCard(
                                          subject: entry['subject'],
                                          time:
                                              '${_formatTime12Hour(entry['startTime'])} - ${_formatTime12Hour(entry['endTime'])}',
                                          location: entry['location'],
                                          color: color,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
