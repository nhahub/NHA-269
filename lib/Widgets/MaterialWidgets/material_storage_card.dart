import 'package:flutter/material.dart';

class MaterialStorageCard extends StatelessWidget {
  final String usedStorage;
  final String totalStorage;
  final int filesCount;
  final double progress;

  const MaterialStorageCard({
    Key? key,
    required this.usedStorage,
    required this.totalStorage,
    required this.filesCount,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Storage Used",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$usedStorage of $totalStorage",
                style: const TextStyle(color: Colors.black87),
              ),
              Text(
                "$filesCount files",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
