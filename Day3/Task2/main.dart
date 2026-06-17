// lib/main.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  final String id;
  final String title;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final _uuid = const Uuid();

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(
        id: _uuid.v4(),
        title: title,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added')),
    );
  }

  void _toggleTask(Task task) {
    setState(() {
      task.toggleDone();
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }

  int get _totalTasks => _tasks.length;
  int get _doneTasks => _tasks.where((t) => t.isDone).length;
  double get _progress => _totalTasks == 0 ? 0 : _doneTasks / _totalTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stats
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total', _totalTasks.toString()),
                        _buildStat('Done', _doneTasks.toString()),
                        _buildStat('Pending', (_totalTasks - _doneTasks).toString()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(_progress * 100).toStringAsFixed(0)}% completed',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task List
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No tasks yet', style: TextStyle(fontSize: 18)),
                        Text('Add some tasks to get started'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _deleteTask(task),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (_) => _toggleTask(task),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isDone ? Colors.grey : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(task),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter task title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                _addTask(title);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
