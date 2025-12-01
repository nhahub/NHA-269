import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/focus_service.dart';
import '../../theme/app_colors.dart';

class FocusProgressCard extends StatelessWidget {
  final FocusService focusService;

  const FocusProgressCard({
    super.key,
    required this.focusService,
  });

  // Helper function to format minutes into "1h 30m"
  String _formatDuration(int totalMinutes) {
    if (totalMinutes == 0) return "0m";
    
    final int hours = totalMinutes ~/ 60; // Integer division
    final int minutes = totalMinutes % 60; // Remainder

    if (hours > 0) {
      // If we have hours and minutes (e.g., 1h 30m) or just hours (e.g., 1h)
      return minutes > 0 ? "${hours}h ${minutes}m" : "${hours}h";
    } else {
      // If less than an hour (e.g., 45m)
      return "${minutes}m";
    }
  }

  Widget _progressBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Slightly smaller font to fit "1h 30m"
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.deepSapphire,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: focusService.getDailyStats(),
      builder: (context, snapshot) {
        
        // Default values
        String focusTimeVal = "0m";
        String restTimeVal = "0m";
        String cyclesVal = "0";

        if (snapshot.hasData) {
          final data = snapshot.data!;
          // Use the helper function to format the minutes
          focusTimeVal = _formatDuration(data['focusMinutes'] ?? 0);
          restTimeVal = _formatDuration(data['restMinutes'] ?? 0);
          cyclesVal = data['cycles'].toString();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSapphire,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _progressBox("Focus Time", focusTimeVal, AppColors.oceanBlue),
                  _progressBox("Rest Time", restTimeVal, AppColors.mintGreen),
                  _progressBox("Cycles", cyclesVal, AppColors.teal),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}