class Task {
  int? id;
  String name;
  bool isDone;
  Task({this.id, required this.name, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      isDone: map['isDone'] == 1,
    );
  }
}
