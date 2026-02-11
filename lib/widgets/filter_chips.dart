import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FilterChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onSelected;

  const FilterChips({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text("All"),
          selected: selectedCategory == null,
          onSelected: (_) => onSelected(null),
        ),
        ...categories.map(
          (c) => ChoiceChip(
            label: Text(c),
            selected: selectedCategory == c,
            onSelected: (_) => onSelected(c),
          ),
        )
      ],
    );
  }
}
