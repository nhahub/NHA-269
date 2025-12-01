import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimetableService {
  static final TimetableService _instance = TimetableService._internal();
  factory TimetableService() => _instance;
  TimetableService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new timetable entry
  Future<void> createTimetableEntry({
    required String subject,
    required String day,
    required String startTime,
    required String endTime,
    required String location,
    required String color,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('timetable')
          .add({
            'subject': subject,
            'day': day,
            'startTime': startTime,
            'endTime': endTime,
            'location': location,
            'color': color,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception("Failed to create timetable entry: $e");
    }
  }

  /// Get all timetable entries
  Future<List<Map<String, dynamic>>> getAllEntries() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('timetable')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch timetable entries: $e");
    }
  }

  /// Get entries for a specific day
  Future<List<Map<String, dynamic>>> getEntriesForDay(String day) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('timetable')
          .where('day', isEqualTo: day)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch entries for day: $e");
    }
  }

  /// Update a timetable entry
  Future<void> updateEntry({
    required String entryId,
    String? subject,
    String? day,
    String? startTime,
    String? endTime,
    String? location,
    String? color,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final Map<String, dynamic> updates = {};

      if (subject != null) updates['subject'] = subject;
      if (day != null) updates['day'] = day;
      if (startTime != null) updates['startTime'] = startTime;
      if (endTime != null) updates['endTime'] = endTime;
      if (location != null) updates['location'] = location;
      if (color != null) updates['color'] = color;

      if (updates.isEmpty) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('timetable')
          .doc(entryId)
          .update(updates);
    } catch (e) {
      throw Exception("Failed to update entry: $e");
    }
  }

  /// Delete a timetable entry
  Future<void> deleteEntry(String entryId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('timetable')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete entry: $e");
    }
  }

  /// Get total hours for the week
  Future<double> getTotalWeeklyHours() async {
    final entries = await getAllEntries();
    double totalHours = 0;

    for (var entry in entries) {
      final start = _parseTime(entry['startTime']);
      final end = _parseTime(entry['endTime']);
      if (start != null && end != null) {
        totalHours += end.difference(start).inMinutes / 60.0;
      }
    }

    return totalHours;
  }

  /// Get total number of classes
  Future<int> getTotalClasses() async {
    final entries = await getAllEntries();
    return entries.length;
  }

  /// Parse time string to DateTime
  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(2000, 1, 1, hour, minute);
    } catch (e) {
      return null;
    }
  }
}
