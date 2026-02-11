import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/task_storage_service.dart';
import '../utils/constants.dart';
import '../widgets/priority_selector.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String category = categories.first;
  int priority = 1;
  final List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            DropdownButton<String>(
              value: category,
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => category = value!);
              },
            ),
            PrioritySelector(
              selected: priority,
              onChanged: (value) {
                setState(() => priority = value);
              },
            ),
            Wrap(
              spacing: 8,
              children: defaultTags.map((tag) {
                final selected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selected
                          ? selectedTags.remove(tag)
                          : selectedTags.add(tag);
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;

                final service =
                    await TaskStorageService.getInstance();

                final task = Task(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text,
                  isCompleted: false,
                  createdAt: DateTime.now(),
                  category: category,
                  priority: priority,
                  tags: selectedTags,
                );

                await service.addTask(task);
                Navigator.pop(context, true);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
