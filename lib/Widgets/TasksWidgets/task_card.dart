import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black..withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: done,
            onChanged: (_) {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)),
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

                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(subtitle,
                          style: const TextStyle(color: AppColors.grey)),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildTag(subject),
                      const SizedBox(width: 8),
                      if (dueText != null)
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 13, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(
                              dueText!,
                              style: TextStyle(
                                  color:AppColors.grey,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: done
                  ? Colors.green.withValues(alpha: 0.1)
                  : (priorityColor ?? Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  done ? Icons.check_circle_outline : Icons.flag_outlined,
                  size: 12,
                  color: done ? Colors.green : (priorityColor ?? Colors.red),
                ),
                const SizedBox(width: 4),
                Text(
                  done ? "Done" : priority!,
                  style: TextStyle(
                    color: done ? Colors.green : (priorityColor ?? Colors.red),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.teal, // always teal background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.white, // text color can still vary
          fontSize: 12,
        ),
      ),
    );
  }
}
