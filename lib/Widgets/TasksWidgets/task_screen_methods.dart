import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learnflow/Widgets/TasksWidgets/edit_task_dialog.dart';
import 'delete_task_dialog.dart';
import 'create_task_dialog.dart';
import '../../theme/app_colors.dart';
import '../../FireBase/task_service.dart';

class TaskScreenMethods {
  /// Load tasks from Firebase
  static Future<void> loadTasks({
    required BuildContext context,
    required TaskService taskService,
    required bool isInitial,
    required Function(bool isInitialLoading, bool isReloading)
    onLoadingStateChange,
    required Function(List<Map<String, dynamic>>, int, int, int) onDataLoaded,
  }) async {
    if (isInitial) {
      onLoadingStateChange(true, false);
    } else {
      onLoadingStateChange(false, true);
    }

    try {
      final tasks = await taskService.getUserTasks();
      final completed = await taskService.getCompletedTasksCount();
      final overdueTasks = await taskService.getOverdueTasks();

      // Calculate pending (not done and not overdue)
      final now = DateTime.now();
      final pending = tasks.where((task) {
        final isDone = task['done'] ?? false;
        final dueDate = task['dueDate'] as DateTime?;
        if (isDone) return false;
        if (dueDate == null) return true;
        return dueDate.isAfter(now) || dueDate.isAtSameMomentAs(now);
      }).length;

      onDataLoaded(tasks, completed, pending, overdueTasks.length);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading tasks: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      onLoadingStateChange(false, false);
    }
  }

  /// Toggle task completion status
  static Future<void> toggleTask({
    required BuildContext context,
    required TaskService taskService,
    required String taskId,
    required bool currentStatus,
    required VoidCallback onSuccess,
  }) async {
    try {
      await taskService.toggleTaskDone(taskId, currentStatus);
      onSuccess();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStatus ? 'Task marked as pending' : 'Task completed!',
            ),
            backgroundColor: AppColors.oceanBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating task: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  /// Delete a task
  static Future<void> deleteTask({
    required BuildContext context,
    required TaskService taskService,
    required String taskId,
    required String title,
    required VoidCallback onSuccess,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteTaskDialog(taskTitle: title),
    );

    if (confirmed == true) {
      try {
        await taskService.deleteTask(taskId);
        onSuccess();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Task deleted successfully',
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.teal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error deleting task: $e',
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }

  /// Edit task
  static Future<void> editTask({
    required BuildContext context,
    required Map<String, dynamic> task,
    required VoidCallback onSuccess,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditTaskDialog(
        taskId: task['id'],
        currentTitle: task['title'] ?? '',
        currentDescription: task['description'] ?? '',
        currentSubject: task['subject'] ?? '',
        currentDueDate: task['dueDate'] ?? DateTime.now(),
        currentPriority: task['priority'] ?? 'medium',
      ),
    );

    if (result == true) {
      onSuccess();
    }
  }

  /// Create new task
  static Future<void> createNewTask({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const TaskCreateDialog(),
    );

    if (result == true) {
      onSuccess();
    }
  }

  // ==================== HELPER UTILITIES ====================

  /// Format due date with smart labels
  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    // Check if it's overdue
    if (difference.isNegative) {
      final overdueDuration = now.difference(dueDate);

      if (overdueDuration.inDays > 0) {
        return 'Overdue by ${overdueDuration.inDays}d';
      } else if (overdueDuration.inHours > 0) {
        return 'Overdue by ${overdueDuration.inHours}h';
      } else {
        return 'Overdue by ${overdueDuration.inMinutes}m';
      }
    }

    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    // Due today
    if (taskDate == today) {
      if (difference.inHours > 0) {
        return 'Due in ${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return 'Due in ${difference.inMinutes}m';
      } else {
        return 'Due now';
      }
    }

    // Due tomorrow
    if (taskDate == tomorrow) {
      return 'Due Tomorrow';
    }

    // Future dates
    if (difference.inDays < 7) {
      return 'Due in ${difference.inDays}d';
    }

    return 'Due ${DateFormat('MMM d').format(dueDate)}';
  }

  /// Get color based on priority level
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
