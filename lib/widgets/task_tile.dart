import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function(bool?) checkboxCallback;
  final Function()? longPressCallback;
  final Function()? deleteCallback;

  const TaskTile({
    super.key,
    required this.taskTitle,
    required this.isChecked,
    required this.checkboxCallback,
    required this.longPressCallback,
    required this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        taskTitle,
        style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked,
            activeColor: Colors.lightBlueAccent,
            onChanged: checkboxCallback,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteCallback,
          ),
        ],
      ),
    );
  }
}
