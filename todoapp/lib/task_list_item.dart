import 'package:flutter/material.dart';
import 'task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(String) onToggle;
  // final VoidCallback onToggle;
  // final VoidCallback onEdit;

  TaskListItem({
    required this.task,
    required this.onToggle,
    // required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<bool>(
        value: true,
        groupValue: task.isDone,
        onChanged: (_) => onToggle(task.id),
      ),
      title: Text(task.title),
      subtitle: Text('Due: ${task.dueDate.toString()}'),
      trailing: Chip(
        label: Text(
          task.priority.toString().split('.').last,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _getPriorityColor(task.priority),
      ),
      // onTap: onEdit,
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.yellow;
      case Priority.high:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
