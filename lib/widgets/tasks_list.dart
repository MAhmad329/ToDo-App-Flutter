import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_data_provider.dart';
import '../screens/edit_task_screen.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDataProvider>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) async {
                await taskData.updateTask(task);
              },
              longPressCallback: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => EditTaskScreen(task),
                );
              },
              deleteCallback: () async {
                await taskData.deleteTask(task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
