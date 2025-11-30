import 'package:flutter/material.dart';
import 'task_card.dart';
import '../../../theme/app_colors.dart';
import 'task_screen_methods.dart';

class TaskListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(String, bool) onToggle;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String, String) onDelete;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  int _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> _getSortedTasks() {
    final sortedTasks = List<Map<String, dynamic>>.from(tasks);

    sortedTasks.sort((a, b) {
      // First, sort by priority (high to low)
      final priorityA = _getPriorityValue(a['priority'] ?? 'medium');
      final priorityB = _getPriorityValue(b['priority'] ?? 'medium');

      if (priorityA != priorityB) {
        return priorityB.compareTo(priorityA); // Descending (high first)
      }

      // If priorities are equal, sort by due date (sooner first)
      final dueDateA = a['dueDate'] as DateTime?;
      final dueDateB = b['dueDate'] as DateTime?;

      // Handle null dates (put them at the end)
      if (dueDateA == null && dueDateB == null) return 0;
      if (dueDateA == null) return 1;
      if (dueDateB == null) return -1;

      return dueDateA.compareTo(dueDateB); // Ascending (sooner first)
    });

    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: AppColors.grey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks here',
              style: TextStyle(color: AppColors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final sortedTasks = _getSortedTasks();

    return Column(
      children: sortedTasks.map((task) {
        final dueDate = task['dueDate'] as DateTime?;
        final priority = task['priority'] as String? ?? 'medium';

        return TaskCard(
          title: task['title'] ?? 'Untitled',
          subtitle: task['description'] ?? '',
          subject: task['subject'] ?? 'General',
          dueText: dueDate != null ? TaskScreenMethods.formatDueDate(dueDate) : null,
          priority:
              priority.substring(0, 1).toUpperCase() + priority.substring(1),
          priorityColor: TaskScreenMethods.getPriorityColor(priority),
          done: task['done'] ?? false,
          onToggle: () => onToggle(task['id'], task['done'] ?? false),
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task['id'], task['title'] ?? 'this task'),
        );
      }).toList(),
    );
  }
}