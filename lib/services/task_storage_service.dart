import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorageService {
  static TaskStorageService? _instance;
  static SharedPreferences? _prefs;

  static const String _tasksKey = 'tasks';

  TaskStorageService._();

  /// Инициализация Singleton
  static Future<TaskStorageService> getInstance() async {
    _instance ??= TaskStorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Публичный геттер (ВАЖНО)
  static TaskStorageService get instance => _instance!;

  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Загрузка задач
  void loadTasks() {
    final jsonString = _prefs?.getString(_tasksKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _tasks
        ..clear()
        ..addAll(decoded.map((e) => Task.fromMap(e)));
    }
  }

  /// Сохранение
  Future<void> _saveTasks() async {
    final jsonString =
        jsonEncode(_tasks.map((e) => e.toMap()).toList());
    await _prefs?.setString(_tasksKey, jsonString);
  }

  /// CREATE
  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
  }

  /// UPDATE
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
    }
  }

  /// DELETE
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _saveTasks();
  }

  /// DELETE COMPLETED
  Future<void> deleteCompleted() async {
    _tasks.removeWhere((t) => t.isCompleted);
    await _saveTasks();
  }

  /// FILTER
  List<Task> filter({String? category, bool? status}) {
    return _tasks.where((t) {
      final categoryMatch =
          category == null || t.category == category;
      final statusMatch =
          status == null || t.isCompleted == status;
      return categoryMatch && statusMatch;
    }).toList();
  }

  /// SORT
  List<Task> sort(List<Task> list, String sortType) {
    final sorted = [...list];
    if (sortType == 'date') {
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortType == 'priority') {
      sorted.sort((a, b) => b.priority.compareTo(a.priority));
    }
    return sorted;
  }

  /// STATS
  int get total => _tasks.length;
  int get completed => _tasks.where((t) => t.isCompleted).length;
  int get active => _tasks.where((t) => !t.isCompleted).length;

  Map<String, int> byCategory() {
    final Map<String, int> map = {};
    for (var t in _tasks) {
      map[t.category] = (map[t.category] ?? 0) + 1;
    }
    return map;
  }
}
