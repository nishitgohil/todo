import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task(this.title, this.dueDate, this.isCompleted);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To-Do App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending Tasks'),
              Tab(text: 'Completed Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ToDoListScreen(isCompleted: false),
            ToDoListScreen(isCompleted: true),
          ],
        ),
      ),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  final bool isCompleted;

  ToDoListScreen({required this.isCompleted});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Task> tasks = [];

  void addTask(String taskTitle, DateTime dueDate) {
    setState(() {
      tasks.add(Task(taskTitle, dueDate, false));
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void editTask(int index, String newTitle, DateTime newDueDate) {
    setState(() {
      tasks[index].title = newTitle;
      tasks[index].dueDate = newDueDate;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks =
        tasks.where((task) => task.isCompleted == widget.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              List<dynamic> newTask = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  String taskTitle = '';
                  DateTime dueDate = DateTime.now();
                  return AlertDialog(
                    title: Text('Add a new task'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            taskTitle = value;
                          },
                        ),
                        SizedBox(height: 10),
                        DatePickerWidget(
                          initialDate: dueDate,
                          onDateSelected: (selectedDate) {
                            dueDate = selectedDate;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Add'),
                        onPressed: () {
                          Navigator.of(context).pop([taskTitle, dueDate]);
                        },
                      ),
                    ],
                  );
                },
              );
              if (newTask != null && newTask.isNotEmpty) {
                String taskTitle = newTask[0];
                DateTime dueDate = newTask[1];
                addTask(taskTitle, dueDate);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredTasks[index].title),
            subtitle: Text(
              "Due Date: ${filteredTasks[index].dueDate.toLocal()}",
            ),
            leading: Checkbox(
              value: filteredTasks[index].isCompleted,
              onChanged: (value) =>
                  toggleTaskCompletion(tasks.indexOf(filteredTasks[index])),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    List<dynamic> updatedTask = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String taskTitle = filteredTasks[index].title;
                        DateTime dueDate = filteredTasks[index].dueDate;
                        return AlertDialog(
                          title: Text('Edit task'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  taskTitle = value;
                                },
                                controller:
                                    TextEditingController(text: taskTitle),
                              ),
                              SizedBox(height: 10),
                              DatePickerWidget(
                                initialDate: dueDate,
                                onDateSelected: (selectedDate) {
                                  dueDate = selectedDate;
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                Navigator.of(context).pop([taskTitle, dueDate]);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (updatedTask != null && updatedTask.isNotEmpty) {
                      String newTitle = updatedTask[0];
                      DateTime newDueDate = updatedTask[1];
                      editTask(tasks.indexOf(filteredTasks[index]), newTitle,
                          newDueDate);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      deleteTask(tasks.indexOf(filteredTasks[index])),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  DatePickerWidget({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Select Due Date:"),
        SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              setState(() {
                selectedDate = picked;
                widget.onDateSelected(selectedDate);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
