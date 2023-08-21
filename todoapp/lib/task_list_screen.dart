import 'package:flutter/material.dart';
import 'package:todoapp/task_list_item.dart';
import 'add_task_screen.dart';
import 'task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _editTask(String taskId, Task updatedTask) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      setState(() {
        tasks[index] = updatedTask;
      });
    }
  }

  void _onToggleTaskStatus(Task task, bool isCompleted) {
    if (isCompleted) {
      setState(() {
        tasks.remove(task);
        completedTasks.add(task);
      });
    } else {
      setState(() {
        completedTasks.remove(task);
        tasks.add(task);
      });
    }
  }

  void deleteTask(String taskId) {
    setState(() {
      tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void sortTasksByPriority() {
    setState(() {
      tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    });
  }

  void sortTasksByDate() {
    setState(() {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_task_sharp),
            onPressed: () async {
              final newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );

              if (newTask != null) {
                _addTask(newTask);
              }
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Added Tasks'),
                Tab(text: 'Completed Tasks'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Added Tasks Tab
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Added Tasks Tab
                        // ListView.builder(
                        //   itemCount: tasks.length,
                        //   itemBuilder: (context, index) {
                        //     final task = tasks[index];
                        //     return TaskListItem(
                        //       task: task,
                        //       onToggle: (bool isCompleted) =>
                        //           _onToggleTaskStatus(task, isCompleted),
                        //     );
                        //   },
                        // ),

                        // Completed Tasks Tab
                        ListView.builder(
                          itemCount: completedTasks.length,
                          itemBuilder: (context, index) {
                            final task = completedTasks[index];
                            return TaskListItem(
                              task: task,
                              onToggle:
                                  (_) {}, // No need to toggle completed tasks
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: sortTasksByPriority,
          child: Text('Sort by Priority'),
        ),
        ElevatedButton(
          onPressed: sortTasksByDate,
          child: Text('Sort by Date'),
        ),
      ],
    );
  }
}
