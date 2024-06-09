import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:todoey_flutter/core/constants/constants.dart';

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool isLoading = false;
  String? errorMessage;
  int totalTasks = 0;
  int limit = 10;
  int skip = 0;

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks({int limit = 10, int skip = 0}) async {
    if (isLoading) return;
    isLoading = true;
    EasyLoading.show(status: 'Fetching tasks...');
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/todos?limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalTasks = data['total'];
        _tasks =
            (data['todos'] as List).map((json) => Task.fromJson(json)).toList();
        errorMessage = null;
      } else {
        errorMessage = 'Failed to fetch tasks';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> fetchTasksByUserId(int userId) async {
    if (isLoading) return;
    isLoading = true;
    EasyLoading.show(status: 'Fetching tasks...');
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/todos/user/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalTasks = data['total'];
        _tasks =
            (data['todos'] as List).map((json) => Task.fromJson(json)).toList();
        errorMessage = null;
      } else {
        errorMessage = 'Failed to fetch tasks';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (isLoading) return;
    if (_tasks.length >= totalTasks) return; // No more tasks to fetch

    skip += limit;
    isLoading = true;
    EasyLoading.show(status: 'Fetching more tasks...');
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/todos?limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newTasks =
            (data['todos'] as List).map((json) => Task.fromJson(json)).toList();
        _tasks.addAll(newTasks);
        errorMessage = null;
      } else {
        errorMessage = 'Failed to fetch tasks';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> fetchTask(int id) async {
    isLoading = true;
    EasyLoading.show(status: 'Fetching task...');
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/todos/$id'),
      );

      if (response.statusCode == 200) {
        final task = Task.fromJson(jsonDecode(response.body));
        _tasks = [..._tasks.where((t) => t.id != id), task];
        errorMessage = null;
      } else {
        errorMessage = 'Failed to fetch task';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> addTask(String todo, bool completed, int userId) async {
    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/todos/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'todo': todo,
          'completed': completed,
          'userId': userId,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final task = Task.fromJson(jsonDecode(response.body));
        print(task.id);
        _tasks.add(task);
        notifyListeners();
        errorMessage = null;
      } else {
        errorMessage = 'Failed to add task';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> updateTask(int id, bool completed) async {
    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.patch(
        Uri.parse('https://dummyjson.com/todos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'completed': completed,
        }),
      );
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final updatedTask = Task.fromJson(jsonDecode(response.body));
        _tasks =
            _tasks.map((task) => task.id == id ? updatedTask : task).toList();
        notifyListeners();
        errorMessage = null;
      } else {
        errorMessage = 'Failed to update task';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.parse('https://dummyjson.com/todos/$id'),
      );

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
        errorMessage = null;
      } else {
        errorMessage = 'Failed to delete task';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
