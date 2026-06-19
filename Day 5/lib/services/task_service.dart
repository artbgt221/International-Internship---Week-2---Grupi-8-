import '../models/task_item.dart';

class TaskService {
  final List<TaskItem> _tasks = [
    TaskItem(
      id: 1,
      title: 'Prepare final demo',
      description: 'Create a short 2-3 minute walkthrough for the internship final project.',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    TaskItem(
      id: 2,
      title: 'Review UI states',
      description: 'Check empty state, completed state, edit flow and delete flow.',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    TaskItem(
      id: 3,
      title: 'Write README reflection',
      description: 'Explain MVP features, what works and what can be improved later.',
      priority: 'Low',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isDone: true,
    ),
  ];

  int _nextId = 4;

  List<TaskItem> getTasks() {
    return List.unmodifiable(_tasks);
  }

  TaskItem addTask({
    required String title,
    required String description,
    required String priority,
    required DateTime dueDate,
  }) {
    final task = TaskItem(
      id: _nextId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );

    _nextId++;
    _tasks.add(task);
    return task;
  }

  void updateTask(TaskItem task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;

    _tasks[index] = task;
  }

  void toggleTaskStatus(TaskItem task) {
    task.isDone = !task.isDone;
  }

  void deleteTask(TaskItem task) {
    _tasks.removeWhere((item) => item.id == task.id);
  }
}
