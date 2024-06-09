import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/providers/task_provider.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.todo,
              isChecked: task.completed,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(
                    task.id, !task.completed); // Pass the task object
              },
              longPressCallback: () {
                taskData.deleteTask(task.id);
              },
            );
          },
          itemCount: taskData.tasks.length,
        );
      },
    );
  }
}
