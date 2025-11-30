import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask({
    required String title,
    required String description,
    required String subject,
    required DateTime dueDate,
    required String priority, 
    bool done = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .add({
        'title': title,
        'description': description,
        'subject': subject,
        'dueDate': Timestamp.fromDate(dueDate),
        'priority': priority,
        'done': done,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to create task: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUserTasks() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .orderBy('dueDate', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        
        // Convert Timestamp fields to DateTime
        final dueDate = data['dueDate'];
        if (dueDate is Timestamp) {
          data['dueDate'] = dueDate.toDate();
        }
        
        final createdAt = data['createdAt'];
        if (createdAt is Timestamp) {
          data['createdAt'] = createdAt.toDate();
        }
        
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch tasks: $e");
    }
  }

  Future<void> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? subject,
    DateTime? dueDate,
    String? priority,
    bool? done,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final Map<String, dynamic> updates = {};
      
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (subject != null) updates['subject'] = subject;
      if (dueDate != null) updates['dueDate'] = Timestamp.fromDate(dueDate);
      if (priority != null) updates['priority'] = priority;
      if (done != null) updates['done'] = done;

      if (updates.isEmpty) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .update(updates);
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }

  Future<void> toggleTaskDone(String taskId, bool currentStatus) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .update({'done': !currentStatus});
    } catch (e) {
      throw Exception("Failed to toggle task status: $e");
    }
  }

  /// Deletes a task.
  Future<void> deleteTask(String taskId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete task: $e");
    }
  }
  
  

  /// Gets overdue tasks (not done and past due date) 
  Future<List<Map<String, dynamic>>> getOverdueTasks() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      // Fetch all incomplete tasks
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .where('done', isEqualTo: false)
          .get();

      final now = DateTime.now();
      
      // Filter overdue tasks client-side
      final overdueTasks = querySnapshot.docs.where((doc) {
        final data = doc.data();
        final dueDate = data['dueDate'];
        if (dueDate is Timestamp) {
          final dueDateObj = dueDate.toDate();
          // Consider overdue if due date/time is before now
          return dueDateObj.isBefore(now);
        }
        return false;
      }).map((doc) {
        final data = doc.data();
        
        final dueDate = data['dueDate'];
        if (dueDate is Timestamp) {
          data['dueDate'] = dueDate.toDate();
        }
        
        final createdAt = data['createdAt'];
        if (createdAt is Timestamp) {
          data['createdAt'] = createdAt.toDate();
        }
        
        return {'id': doc.id, ...data};
      }).toList();

      // Sort tasks by their due dates in ascending order
      overdueTasks.sort((a, b) {
        final dateA = a['dueDate'] as DateTime?;
        final dateB = b['dueDate'] as DateTime?;
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });

      return overdueTasks;
    } catch (e) {
      throw Exception("Failed to fetch overdue tasks: $e");
    }
  }

  /// Counts total tasks.
  Future<int> getTotalTasksCount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception("Failed to get total tasks count: $e");
    }
  }

  /// Counts completed tasks.
  Future<int> getCompletedTasksCount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .where('done', isEqualTo: true)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception("Failed to get completed tasks count: $e");
    }
  }

  /// Counts pending tasks (not done and not overdue).
  Future<int> getPendingTasksCount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .where('done', isEqualTo: false)
          .get();

      final now = DateTime.now();

      // Count only tasks that are not overdue (due in the future or right now)
      int pendingCount = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final dueDate = data['dueDate'];
        if (dueDate is Timestamp) {
          final dueDateObj = dueDate.toDate();
          // Include tasks due now or in the future (includes hours, minutes, seconds)
          if (dueDateObj.isAfter(now) || dueDateObj.isAtSameMomentAs(now)) {
            pendingCount++;
          }
        } else {
          // If no due date, count as pending
          pendingCount++;
        }
      }

      return pendingCount;
    } catch (e) {
      throw Exception("Failed to get pending tasks count: $e");
    }
  }
}