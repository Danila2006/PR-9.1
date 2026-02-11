import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/helpers.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: onChanged,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
              task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          Text(
            "Category: ${task.category}",
            style: const TextStyle(fontSize: 12),
          ),
          Wrap(
            spacing: 6,
            children: task.tags
                .map((tag) => Chip(label: Text(tag)))
                .toList(),
          )
        ],
      ),
      trailing: CircleAvatar(
        radius: 10,
        backgroundColor: priorityColor(task.priority),
      ),
    );
  }
}
