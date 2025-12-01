import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class DeleteEntryDialog extends StatelessWidget {
  final String entryTitle;

  const DeleteEntryDialog({
    super.key,
    required this.entryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete Entry',
        style: TextStyle(
          color: AppColors.deepSapphire,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "$entryTitle"?',
        style: const TextStyle(
          color: AppColors.deepSapphire,
          fontSize: 16,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.oceanBlue,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}