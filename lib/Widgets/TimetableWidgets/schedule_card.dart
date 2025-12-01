import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../theme/app_colors.dart';

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(entry['color']));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(entry['id']),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(),
              backgroundColor: AppColors.oceanBlue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
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
                color: Colors.black.withAlpha((0.08 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['subject'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.deepSapphire,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${entry['startTime']} - ${entry['endTime']}',
                          style: const TextStyle(fontSize: 13, color: AppColors.grey),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            entry['location'],
                            style: const TextStyle(fontSize: 13, color: AppColors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
}