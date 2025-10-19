import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/material_service.dart';
import 'package:learnflow/theme/app_colors.dart';

class DeleteMaterialDialog extends StatefulWidget {
  final String materialId;
  final String fileId;

  const DeleteMaterialDialog({
    super.key,
    required this.materialId,
    required this.fileId,
  });

  @override
  State<DeleteMaterialDialog> createState() => _DeleteMaterialDialogState();
}

class _DeleteMaterialDialogState extends State<DeleteMaterialDialog> {
  bool _isDeleting = false;
  String? _message;
  Color _messageColor = AppColors.grey;

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  Future<void> _handleDelete(BuildContext context) async {
    final service = MaterialService();

    setState(() {
      _isDeleting = true;
      _message = "Deleting material, please wait...";
      _messageColor = AppColors.oceanBlue;
    });

    try {
      await service.deleteMaterialEverywhere(
        materialId: widget.materialId,
        fileId: widget.fileId,
      );

      _setMessage('Material deleted successfully!', AppColors.teal);

      // Give the message a moment to show before closing the dialog
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _setMessage('Error deleting material: $e', Colors.redAccent);
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Delete Material',
        style: TextStyle(
          color: AppColors.deepSapphire,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to permanently delete this material?",
              style: TextStyle(color: AppColors.grey, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: _messageColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _messageColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.oceanBlue,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _isDeleting ? null : () => _handleDelete(context),
              child: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
