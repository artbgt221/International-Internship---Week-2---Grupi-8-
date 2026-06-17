import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskItem {
  final String title;
  final String description;
  bool done;

  TaskItem({
    required this.title,
    required this.description,
    this.done = false,
  });
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<TaskItem> tasks = [
    TaskItem(
      title: 'Practice Flutter',
      description: 'Review widgets, layout, and setState.',
    ),
    TaskItem(
      title: 'Finish Day 3 Task',
      description: 'Create dynamic list and navigation screen.',
    ),
  ];

  String errorMessage = '';

  void showMessage(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void addTask() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      setState(() {
        errorMessage = 'Please fill both fields.';
      });
      return;
    }

    setState(() {
      tasks.add(
        TaskItem(
          title: title,
          description: description,
        ),
      );

      titleController.clear();
      descriptionController.clear();
      errorMessage = '';
    });

    showMessage('Task added successfully!');
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    showMessage('Task deleted!');
  }

  void toggleDone(int index) {
    setState(() {
      tasks[index].done = !tasks[index].done;
    });
  }

  void openDetails(TaskItem task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'Day 3 Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFECEFF1),
        appBar: AppBar(
          title: const Text('Task Manager'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.playlist_add_check,
                                size: 75,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Add New Task',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Task title',
                                  prefixIcon: Icon(Icons.title),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Task description',
                                  prefixIcon: Icon(Icons.description),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (errorMessage.isNotEmpty)
                                Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: addTask,
                                  child: const Text('Add Task'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Task List',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.done,
                                onChanged: (value) {
                                  toggleDone(index);
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: task.done
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                task.done ? 'Completed' : 'Not completed',
                              ),
                              onTap: () {
                                openDetails(task);
                              },
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteTask(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskDetailsScreen extends StatelessWidget {
  final TaskItem task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    task.done ? Icons.check_circle : Icons.pending_actions,
                    size: 80,
                    color: task.done ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    task.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    task.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    task.done ? 'Status: Completed' : 'Status: Not completed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: task.done ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
