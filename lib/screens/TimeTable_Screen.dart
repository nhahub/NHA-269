import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../FireBase/timetable_service.dart';
import '../Widgets/TimetableWidgets/day_selector.dart';
import '../Widgets/TimetableWidgets/schedule_card.dart';
import '../Widgets/TimetableWidgets/weekly_overview.dart';
import '../Widgets/TimetableWidgets/create_entry_dialog.dart';
import '../Widgets/TimetableWidgets/edit_entry_dialog.dart';
import '../Widgets/TimetableWidgets/delete_entry_dialog.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final TimetableService _timetableService = TimetableService();
  int _selectedDayIndex = 0;
  bool _isLoading = true;
  bool _isReloading = false;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  Map<String, List<Map<String, dynamic>>> _scheduleData = {};
  double _totalHours = 0;
  int _totalClasses = 0;

  @override
  void initState() {
    super.initState();
    _loadTimetable(isInitial: true);
  }

  Future<void> _loadTimetable({bool isInitial = false}) async {
    if (isInitial) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isReloading = true);
    }

    try {
      final allEntries = await _timetableService.getAllEntries();
      final totalHours = await _timetableService.getTotalWeeklyHours();
      final totalClasses = await _timetableService.getTotalClasses();

      // Organize entries by day
      Map<String, List<Map<String, dynamic>>> organized = {
        for (var day in _days) day: []
      };

      for (var entry in allEntries) {
        final day = entry['day'];
        if (organized.containsKey(day)) {
          organized[day]!.add(entry);
        }
      }

      // Sort entries by start time
      for (var day in organized.keys) {
        organized[day]!.sort((a, b) {
          return a['startTime'].compareTo(b['startTime']);
        });
      }

      setState(() {
        _scheduleData = organized;
        _totalHours = totalHours;
        _totalClasses = totalClasses;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading timetable: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isReloading = false;
      });
    }
  }

  Future<void> _createEntry() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateEntryDialog(),
    );

    if (result == true) {
      await _loadTimetable();
    }
  }

  Future<void> _editEntry(Map<String, dynamic> entry) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditEntryDialog(entry: entry),
    );

    if (result == true) {
      await _loadTimetable();
    }
  }

  Future<void> _deleteEntry(String entryId, String subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteEntryDialog(entryTitle: subject),
    );

    if (confirmed == true) {
      try {
        await _timetableService.deleteEntry(entryId);
        await _loadTimetable();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Entry deleted successfully'),
              backgroundColor: AppColors.teal,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting entry: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDay = _days[_selectedDayIndex];
    List<Map<String, dynamic>> todaySchedule = _scheduleData[selectedDay] ?? [];

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        elevation: 0,
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Timetable',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.deepSapphire,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your weekly schedule',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.deepSapphire),
            onPressed: () => _loadTimetable(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.oceanBlue),
            )
          : Stack(
              children: [
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _loadTimetable,
                    color: AppColors.oceanBlue,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DaySelector(
                            days: _days,
                            selectedIndex: _selectedDayIndex,
                            onDaySelected: (index) {
                              setState(() => _selectedDayIndex = index);
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$selectedDay Schedule',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.deepSapphire,
                            ),
                          ),
                          const SizedBox(height: 12),
                          todaySchedule.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(40),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        size: 64,
                                        color: AppColors.grey.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No classes scheduled for this day',
                                        style: TextStyle(color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: todaySchedule.map((entry) {
                                    return ScheduleCard(
                                      entry: entry,
                                      onEdit: () => _editEntry(entry),
                                      onDelete: () => _deleteEntry(
                                        entry['id'],
                                        entry['subject'],
                                      ),
                                    );
                                  }).toList(),
                                ),
                          const SizedBox(height: 16),
                          WeeklyOverview(
                            totalHours: _totalHours,
                            totalClasses: _totalClasses,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isReloading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.oceanBlue,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Updating...',
                                style: TextStyle(
                                  color: AppColors.deepSapphire,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEntry,
        backgroundColor: AppColors.oceanBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}