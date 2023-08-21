enum Priority { low, medium, high }

class Task {
  final String id;
  String title; // Make it non-final
  String category; // Make it non-final
  DateTime dueDate; // Make it non-final
  bool isDone;
  Priority priority;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    this.isDone = false,
    this.priority = Priority.low,
  });

  Task copyWith({
    bool? isDone,
    String? title,
    String? category,
    DateTime? dueDate,
    Priority? priority,
  }) {
    return Task(
      id: this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
    );
  }
}
