import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/database_helper.dart';

class TaskDataProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  TaskDataProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  Future<void> addTask(String newTaskTitle) async {
    final task = Task(name: newTaskTitle);
    await DatabaseHelper().insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    task.toggleDone();
    await DatabaseHelper().updateTask(task);
    notifyListeners();
  }

  Future<void> editTask(Task task, String newName) async {
    task.name = newName;
    await DatabaseHelper().updateTask(task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await DatabaseHelper().deleteTask(task.id!);
    _tasks.remove(task);
    notifyListeners();
  }
}
