import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String subject;
  final String? dueText;
  final String? priority;
  final Color? priorityColor;
  final Color? tagColor;
  final bool done;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.subject,
    this.dueText,
    this.priority,
    this.priorityColor,
    this.tagColor,
    this.done = false,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  // Determine the color based on due date status
  Color _getDueTextColor() {
    if (dueText == null) return AppColors.grey;

    final lowerText = dueText!.toLowerCase();

    // Overdue - Red
    if (lowerText.contains('overdue')) {
      return Colors.red;
    }

    // Today or in hours/minutes - Orange
    if (lowerText.contains('due in') &&
        (lowerText.contains('h') || lowerText.contains('m'))) {
      return Colors.orange;
    }

    if (lowerText.contains('due now') || lowerText.contains('due today')) {
      return Colors.orange;
    }

    // Future dates - Grey
    return AppColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final dueColor = _getDueTextColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(title),
        // Swipe RIGHT → Edit
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit?.call(),
              backgroundColor: AppColors.oceanBlue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        // Swipe LEFT → Delete
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete?.call(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: done,
                onChanged: (_) => onToggle?.call(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                activeColor: AppColors.oceanBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Opacity(
                  opacity: done ? 0.6 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: AppColors.deepSapphire,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            style: const TextStyle(color: AppColors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(child: _buildTag(subject)),
                          // Only show due date if task is NOT done
                          if (!done && dueText != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 13, color: dueColor),
                            const SizedBox(width: 4),
                            Text(
                              dueText!,
                              style: TextStyle(
                                color: dueColor,
                                fontSize: 13,
                                fontWeight: dueColor != AppColors.grey
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green.withValues(alpha: 0.1)
                      : (priorityColor ?? Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      done ? Icons.check_circle_outline : Icons.flag_outlined,
                      size: 12,
                      color: done
                          ? Colors.green
                          : (priorityColor ?? Colors.red),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      done ? "Done" : priority!,
                      style: TextStyle(
                        color: done
                            ? Colors.green
                            : (priorityColor ?? Colors.red),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.white, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
