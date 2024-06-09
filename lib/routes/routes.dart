import 'package:flutter/material.dart';
import 'package:todoey_flutter/screens/login_screen.dart';
import 'package:todoey_flutter/screens/tasks_screen.dart';

class AppRoutes {
  static const String tasksScreen = '/tasks';
  static const String login = '/login';

  static Map<String, WidgetBuilder> routes = {
    tasksScreen: (context) => TasksScreen(),
    login: (context) => const LoginScreen(),
  };
}
