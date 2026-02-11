import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final int selected;
  final Function(int) onChanged;

  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 1, label: Text("Low")),
        ButtonSegment(value: 2, label: Text("Medium")),
        ButtonSegment(value: 3, label: Text("High")),
      ],
      selected: {selected},
      onSelectionChanged: (value) {
        onChanged(value.first);
      },
    );
  }
}
