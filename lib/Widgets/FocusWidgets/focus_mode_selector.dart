import 'package:flutter/material.dart';

class FocusModeSelector extends StatefulWidget {
  const FocusModeSelector({Key? key}) : super(key: key);

  @override
  State<FocusModeSelector> createState() => _FocusModeSelectorState();
}

class _FocusModeSelectorState extends State<FocusModeSelector> {
  int selectedIndex = 0;

  final List<String> modes = ["Focus", "Short Break", "Long Break"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(modes.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(modes[index]),
            selected: isSelected,
            selectedColor: Colors.blue[700],
            onSelected: (_) {
              setState(() {
                selectedIndex = index;
              });
            },
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.grey[200],
          ),
        );
      }),
    );
  }
}
