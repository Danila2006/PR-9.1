import 'package:flutter/material.dart';
import '../services/task_storage_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TaskStorageService.instance;
    final byCategory = service.byCategory();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total: ${service.total}"),
            Text("Completed: ${service.completed}"),
            Text("Active: ${service.active}"),
            const SizedBox(height: 20),
            const Text("By Category:"),
            ...byCategory.entries.map(
              (e) => Text("${e.key}: ${e.value}"),
            ),
          ],
        ),
      ),
    );
  }
}
