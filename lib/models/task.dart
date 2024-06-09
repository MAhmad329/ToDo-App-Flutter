class Task {
  final int id;
  final String todo;
  final bool completed;
  final int userId;
  bool isDeleted;
  DateTime? deletedOn;

  Task({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
    this.isDeleted = false,
    this.deletedOn,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
      isDeleted: json['isDeleted'] ?? false,
      deletedOn:
          json['deletedOn'] != null ? DateTime.parse(json['deletedOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
      'isDeleted': isDeleted,
      'deletedOn': deletedOn?.toIso8601String(),
    };
  }
}
