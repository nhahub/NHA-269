import 'package:flutter/material.dart';

class TimerControlCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color themeColor; // The active color (Ocean, Teal, Mint)
  final int seconds;
  final bool isRunning;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onStop;

  const TimerControlCard({
    super.key,
    required this.title,
    required this.icon,
    required this.themeColor,
    required this.seconds,
    required this.isRunning,
    required this.onPlayPause,
    required this.onReset,
    required this.onStop,
  });

  String get formattedTime {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title and Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: themeColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: themeColor, // Matches the requested style
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Timer Display
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: themeColor, // Matches the requested style
            ),
          ),
          const SizedBox(height: 24),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RESET BUTTON
              _buildControlButton(
                icon: Icons.refresh,
                onTap: onReset,
                color: Colors.grey.shade100,
                iconColor: Colors.grey,
              ),
              const SizedBox(width: 20),
              
              // PLAY/PAUSE BUTTON
              GestureDetector(
                onTap: onPlayPause,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: themeColor, // Dynamic button color
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // STOP BUTTON
              _buildControlButton(
                icon: Icons.stop,
                onTap: onStop,
                color: Colors.red.withValues(alpha: 0.1),
                iconColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}