import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String category;
  final int priority; // 1-3
  final List<String> tags;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    required this.category,
    required this.priority,
    required this.tags,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? category,
    int? priority,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'category': category,
        'priority': priority,
        'tags': tags,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
        createdAt: DateTime.parse(map['createdAt']),
        completedAt: map['completedAt'] != null
            ? DateTime.parse(map['completedAt'])
            : null,
        category: map['category'] ?? '',
        priority: map['priority'] ?? 1,
        tags: List<String>.from(map['tags'] ?? []),
      );

  String toJson() => jsonEncode(toMap());
  factory Task.fromJson(String source) =>
      Task.fromMap(jsonDecode(source));
}
