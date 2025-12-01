import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FocusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the reference to the current user's session collection.
  /// Returns null if user is not logged in.
  CollectionReference? get _sessionsRef {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("Warning: No user logged in. Cannot access Firestore.");
      return null;
    }
    return _firestore.collection('users').doc(user.uid).collection('sessions');
  }

  /// Saves a focus or break session to Firestore.
  /// [type]: 'Focus', 'Short Break', or 'Long Break'
  /// [durationSeconds]: How long the timer ran (actual elapsed time)
  /// [completed]: True if timer hit 0, False if stopped manually
  Future<void> saveSession({
    required String type,
    required int durationSeconds,
    required bool completed,
  }) async {
    final ref = _sessionsRef;
    if (ref == null) return;

    // Optional: Ignore very short accidental sessions (e.g., less than 10 seconds)
    if (durationSeconds < 10) return;

    try {
      await ref.add({
        'type': type,
        'durationSeconds': durationSeconds,
        'timestamp': FieldValue.serverTimestamp(),
        'completed': completed,
      });
      debugPrint("Session saved: $type ($durationSeconds s)");
    } catch (e) {
      debugPrint("Error saving session: $e");
    }
  }

  /// Retrieves statistics for the *current day* only.
  /// Used for the "Today's Progress" card.
  /// Returns a Map with: 'focusHours', 'restHours', 'cycles'.
  Future<Map<String, dynamic>> getDailyStats() async {
    final ref = _sessionsRef;
    if (ref == null) {
      return {'focusMinutes': 0, 'restMinutes': 0, 'cycles': 0};
    }

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final Timestamp startTimestamp = Timestamp.fromDate(startOfDay);

      QuerySnapshot snapshot = await ref
          .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
          .get();

      // Use integer for seconds to be precise
      int focusSeconds = 0;
      int restSeconds = 0;
      int completedFocusSessions = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['type'] as String? ?? 'Focus';
        final seconds = (data['durationSeconds'] as num?)?.toInt() ?? 0;
        final completed = data['completed'] as bool? ?? false;

        if (type == 'Focus') {
          focusSeconds += seconds;
          if (completed) completedFocusSessions++;
        } else {
          restSeconds += seconds;
        }
      }

      // Convert total seconds to total minutes
      int focusMinutes = (focusSeconds / 60).floor();
      int restMinutes = (restSeconds / 60).floor();
      int cycles = (completedFocusSessions / 4).floor();

      return {
        'focusMinutes': focusMinutes, // Changed from hours to minutes
        'restMinutes': restMinutes, // Changed from hours to minutes
        'cycles': cycles,
      };
    } catch (e) {
      debugPrint("Error getting daily stats: $e");
      return {'focusMinutes': 0, 'restMinutes': 0, 'cycles': 0};
    }
  }
/// Fetches focus duration (in minutes) for each day in the past [days] range.
  /// Returns a Map where Key = "MM-DD" (String) and Value = Minutes (double).
  Future<Map<String, double>> getHistoryStats(int days) async {
    final ref = _sessionsRef;
    if (ref == null) return {};

    try {
      final now = DateTime.now();
      // Calculate the start date (e.g., 7 days ago)
      final startDate = now.subtract(Duration(days: days));
      final startTimestamp = Timestamp.fromDate(
        DateTime(startDate.year, startDate.month, startDate.day),
      );

      // Query sessions from that date onwards
      final snapshot = await ref
          .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
          .orderBy('timestamp') // Order is important for the chart
          .get();

      // Initialize the map with 0.0 for all days in the range (so empty days show 0)
      Map<String, double> history = {};
      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: (days - 1) - i));
        // Format: "10-24" (Month-Day)
        final key = "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        history[key] = 0.0;
      }

      // Fill in actual data
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['type'] as String? ?? 'Focus';
        
        // We only chart "Focus" time, not breaks
        if (type != 'Focus') continue; 

        final timestamp = data['timestamp'] as Timestamp?;
        final seconds = (data['durationSeconds'] as num?)?.toInt() ?? 0;

        if (timestamp != null) {
          final date = timestamp.toDate();
          final key = "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

          if (history.containsKey(key)) {
            // Convert seconds to minutes
            history[key] = (history[key] ?? 0) + (seconds / 60);
          }
        }
      }

      return history;
    } catch (e) {
      debugPrint("Error fetching history: $e");
      return {};
    }
  }
  /// Calculates the current study streak in days.
  /// Logic:
  /// - If you studied today: Count today + consecutive previous days.
  /// - If you haven't studied today yet: Check yesterday.
  ///   - If you studied yesterday: Count yesterday + consecutive previous days.
  ///   - If not: Streak is 0.
  Future<int> getStudyStreak() async {
    final ref = _sessionsRef;
    if (ref == null) return 0;

    try {
      // 1. Get recent sessions ordered by date (newest first)
      // Limit to 365 to be safe, though usually fewer are needed for calculation
      final snapshot = await ref
          .orderBy('timestamp', descending: true)
          .limit(365)
          .get();

      if (snapshot.docs.isEmpty) return 0;

      // 2. Extract unique dates where the user studied
      final Set<String> studyDates = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Timestamp? ts = data['timestamp'] as Timestamp?;

        // Only count 'Focus' sessions towards the streak (optional, based on preference)
        // If you want breaks to count too, remove this if statement.
        final type = data['type'] as String? ?? 'Focus';

        if (ts != null && type == 'Focus') {
          final date = ts.toDate();
          // Store as "YYYY-M-D" string key
          final dateKey = "${date.year}-${date.month}-${date.day}";
          studyDates.add(dateKey);
        }
      }

      // 3. Calculate Streak Logic
      int streak = 0;
      final now = DateTime.now();

      // Keys for Today and Yesterday
      final todayKey = "${now.year}-${now.month}-${now.day}";

      bool studiedToday = studyDates.contains(todayKey);

      // Start counting
      if (studiedToday) {
        streak = 1;
      }

      // Check backwards
      // If we studied today, we start checking from 1 day ago (yesterday).
      // If we didn't study today, we strictly MUST have studied 1 day ago (yesterday) to keep streak.
      int daysBack = 1;

      while (true) {
        final pastDate = now.subtract(Duration(days: daysBack));
        final pastKey = "${pastDate.year}-${pastDate.month}-${pastDate.day}";

        if (studyDates.contains(pastKey)) {
          streak++;
          daysBack++;
        } else {
          // Break the loop if a gap is found
          // Special Case: If we didn't study today, and loop breaks at yesterday (daysBack=1),
          // streak stays 0.
          break;
        }
      }

      return streak;
    } catch (e) {
      debugPrint("Error calculating streak: $e");
      return 0;
    }
  }
}
