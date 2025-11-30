import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/task_service.dart';
import 'package:learnflow/Widgets/Shared/text_field.dart';
import 'package:learnflow/theme/app_colors.dart';
import 'package:intl/intl.dart';

class TaskCreateDialog extends StatefulWidget {
  const TaskCreateDialog({super.key});

  @override
  State<TaskCreateDialog> createState() => _TaskCreateDialogState();
}

class _TaskCreateDialogState extends State<TaskCreateDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  DateTime? _selectedDueDate;
  String? _selectedPriority;
  bool _isCreating = false;
  String? _message;
  Color _messageColor = AppColors.grey;

  final _formKey = GlobalKey<FormState>();

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.oceanBlue,
              onPrimary: AppColors.white,
              onSurface: AppColors.deepSapphire,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Show time picker after date is selected
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.oceanBlue,
                onPrimary: AppColors.white,
                onSurface: AppColors.deepSapphire,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPriority == null) {
      _setMessage('Please select a priority level.', Colors.redAccent);
      return;
    }

    if (_selectedDueDate == null) {
      _setMessage('Please select a due date.', Colors.redAccent);
      return;
    }

    setState(() {
      _isCreating = true;
      _message = "Creating task, please wait...";
      _messageColor = AppColors.oceanBlue;
    });

    try {
      await TaskService().createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        subject: _subjectController.text.trim(),
        dueDate: _selectedDueDate!,
        priority: _selectedPriority!.toLowerCase(),
      );

      _setMessage('Task created successfully!', AppColors.teal);
      
      // Wait a moment to show success message, then close
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      _setMessage('Failed to create task: $e', Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  Widget _buildPriorityButton(String priority, Color color) {
    final isSelected = _selectedPriority == priority;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedPriority = priority),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : AppColors.grey,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(priority),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Create New Task',
        style: TextStyle(
          color: AppColors.deepSapphire,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(
                'Enter task title',
                Icons.title,
                controller: _titleController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Enter description (optional)',
                Icons.description_outlined,
                controller: _descriptionController, validator: null,
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Enter subject',
                Icons.book_outlined,
                controller: _subjectController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a subject' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Priority',
                style: TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityButton("Low", Colors.green),
                  const SizedBox(width: 8),
                  _buildPriorityButton("Medium", Colors.orange),
                  const SizedBox(width: 8),
                  _buildPriorityButton("High", Colors.red),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _selectDueDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepSapphire,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  _selectedDueDate == null
                      ? 'Select Due Date & Time'
                      : DateFormat('MMM dd, yyyy - hh:mm a')
                          .format(_selectedDueDate!),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              if (_message != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _messageColor.withAlpha((0.1 * 255).toInt()),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _isCreating ? null : _createTask,
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}