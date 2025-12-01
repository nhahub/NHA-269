import 'package:flutter/material.dart';
import '../../FireBase/timetable_service.dart';
import '../../theme/app_colors.dart';
import '../Shared/text_field.dart';

class EditEntryDialog extends StatefulWidget {
  final Map<String, dynamic> entry;

  const EditEntryDialog({super.key, required this.entry});

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  late TextEditingController _subjectController;
  late TextEditingController _locationController;

  String? _selectedDay;
  String? _startTime;
  String? _endTime;
  late Color _selectedColor;
  bool _isUpdating = false;
  String? _message;
  Color _messageColor = AppColors.grey;

  final _formKey = GlobalKey<FormState>();

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<Color> _colors = [
    const Color(0xFF0D47A1),
    const Color(0xFF00796B),
    const Color(0xFF66BB6A),
    const Color(0xFF8E24AA),
    const Color(0xFFEF5350),
    const Color(0xFFFF9800),
    const Color(0xFFEC407A),
  ];

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.entry['subject']);
    _locationController = TextEditingController(text: widget.entry['location']);
    _selectedDay = widget.entry['day'];
    _startTime = widget.entry['startTime'];
    _endTime = widget.entry['endTime'];
    _selectedColor = Color(int.parse(widget.entry['color']));
  }

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
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

    if (picked != null) {
      setState(() {
        final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  Future<void> _updateEntry() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDay == null) {
      _setMessage('Please select a day', Colors.redAccent);
      return;
    }

    if (_startTime == null || _endTime == null) {
      _setMessage('Please select start and end times', Colors.redAccent);
      return;
    }

    setState(() {
      _isUpdating = true;
      _message = "Updating entry, please wait...";
      _messageColor = AppColors.oceanBlue;
    });

    try {
      await TimetableService().updateEntry(
        entryId: widget.entry['id'],
        subject: _subjectController.text.trim(),
        day: _selectedDay!,
        startTime: _startTime!,
        endTime: _endTime!,
        location: _locationController.text.trim(),
        color: '0x${_selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      );

      _setMessage('Entry updated successfully!', AppColors.teal);

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _setMessage('Failed to update entry: $e', Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Edit Timetable Entry',
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
                'Enter subject name',
                Icons.book_outlined,
                controller: _subjectController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a subject' : null,
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Enter location',
                Icons.location_on_outlined,
                controller: _locationController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a location' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Day',
                style: TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Select day'),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDay = value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Time',
                          style: TextStyle(
                            color: AppColors.deepSapphire,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _selectTime(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepSapphire,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.access_time, size: 18),
                          label: Text(
                            _startTime ?? 'Select',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Time',
                          style: TextStyle(
                            color: AppColors.deepSapphire,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _selectTime(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepSapphire,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.access_time, size: 18),
                          label: Text(
                            _endTime ?? 'Select',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Color',
                style: TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppColors.deepSapphire, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _isUpdating ? null : _updateEntry,
              child: _isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}