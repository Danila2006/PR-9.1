import 'package:flutter/material.dart';
import '../services/task_storage_service.dart';
import '../widgets/task_item.dart';
import '../widgets/filter_chips.dart';
import 'create_task_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  String sortType = 'date';

  @override
  Widget build(BuildContext context) {
    final service = TaskStorageService.instance;

    var tasks = service.filter(category: selectedCategory);
    tasks = service.sort(tasks, sortType);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StatsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await service.deleteCompleted();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            selectedCategory: selectedCategory,
            onSelected: (value) {
              setState(() => selectedCategory = value);
            },
          ),
          DropdownButton<String>(
            value: sortType,
            items: const [
              DropdownMenuItem(
                value: 'date',
                child: Text("Sort by Date"),
              ),
              DropdownMenuItem(
                value: 'priority',
                child: Text("Sort by Priority"),
              ),
            ],
            onChanged: (value) {
              setState(() => sortType = value!);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];

                return Dismissible(
                  key: Key(task.id),
                  background: Container(color: Colors.red),
                  onDismissed: (_) async {
                    await service.deleteTask(task.id);
                    setState(() {});

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: const Text("Task deleted"),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () async {
                            await service.addTask(task);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  child: TaskItem(
                    task: task,
                    onChanged: (value) async {
                      final updated = task.copyWith(
                        isCompleted: value ?? false,
                        completedAt: value == true
                            ? DateTime.now()
                            : null,
                      );
                      await service.updateTask(updated);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTaskScreen(),
            ),
          );
          if (result == true) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
