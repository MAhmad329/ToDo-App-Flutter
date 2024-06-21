import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_data_provider.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  const EditTaskScreen(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    late String editedTaskTitle = task.name;

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 26,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                editedTaskTitle = newText;
              },
              controller: TextEditingController()..text = task.name,
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<TaskDataProvider>(context, listen: false)
                    .editTask(task, editedTaskTitle);
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
