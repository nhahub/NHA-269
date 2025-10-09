
import 'package:flutter/material.dart';
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}
