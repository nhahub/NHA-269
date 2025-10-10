import 'package:flutter/material.dart';

class FocusTimerCard extends StatelessWidget {
  final String timeText;
  final bool isRunning;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;

  const FocusTimerCard({
    Key? key,
    required this.timeText,
    required this.isRunning,
    required this.onPlayPause,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.blur_circular, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              "Focus Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              timeText,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isRunning ? "Running..." : "Paused",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 30,
                  onPressed: onReset,
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: onPlayPause,
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.alarm),
                  iconSize: 30,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
