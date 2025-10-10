import 'package:flutter/material.dart';

class MaterialFilterBar extends StatelessWidget {
  final String selected;
  final Function(String) onFilterChanged;

  const MaterialFilterBar({
    Key? key,
    required this.selected,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Notes", "PDFs", "Videos", "Images"];

    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: filters.map((filter) {
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
