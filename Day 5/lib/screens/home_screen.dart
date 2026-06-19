import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../services/task_service.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

enum TaskFilter { all, active, done }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();
  TaskFilter selectedFilter = TaskFilter.all;

  List<TaskItem> get visibleTasks {
    final tasks = taskService.getTasks();

    switch (selectedFilter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isDone).toList();
      case TaskFilter.done:
        return tasks.where((task) => task.isDone).toList();
      case TaskFilter.all:
        return tasks;
    }
  }

  int get completedCount {
    return taskService.getTasks().where((task) => task.isDone).length;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> openCreateTask() async {
    final createdTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(
        builder: (_) => const TaskFormScreen(),
      ),
    );

    if (createdTask == null) return;

    setState(() {
      taskService.addTask(
        title: createdTask.title,
        description: createdTask.description,
        priority: createdTask.priority,
        dueDate: createdTask.dueDate,
      );
    });

    showMessage('Task added successfully.');
  }

  Future<void> openTaskDetails(TaskItem task) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );

    if (result == 'edit') {
      await openEditTask(task);
    }
  }

  Future<void> openEditTask(TaskItem task) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(existingTask: task),
      ),
    );

    if (updatedTask == null) return;

    setState(() {
      taskService.updateTask(updatedTask);
    });

    showMessage('Task updated.');
  }

  void toggleTask(TaskItem task) {
    setState(() {
      taskService.toggleTaskStatus(task);
    });

    showMessage(task.isDone ? 'Task completed.' : 'Task marked active.');
  }

  void deleteTask(TaskItem task) {
    setState(() {
      taskService.deleteTask(task);
    });

    showMessage('Task deleted.');
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskService.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Project: Task Manager'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCreateTask,
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SummaryTile(label: 'Total', value: '${tasks.length}'),
                      SummaryTile(label: 'Active', value: '${tasks.length - completedCount}'),
                      SummaryTile(label: 'Done', value: '$completedCount'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<TaskFilter>(
                    segments: const [
                      ButtonSegment(value: TaskFilter.all, label: Text('All')),
                      ButtonSegment(value: TaskFilter.active, label: Text('Active')),
                      ButtonSegment(value: TaskFilter.done, label: Text('Done')),
                    ],
                    selected: {selectedFilter},
                    onSelectionChanged: (selection) {
                      setState(() {
                        selectedFilter = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: visibleTasks.isEmpty
                        ? const EmptyState()
                        : ListView.separated(
                            itemCount: visibleTasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = visibleTasks[index];

                              return TaskCard(
                                task: task,
                                onOpen: () => openTaskDetails(task),
                                onEdit: () => openEditTask(task),
                                onToggle: () => toggleTask(task),
                                onDelete: () => deleteTask(task),
                              );
                            },
                          ),
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

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFD8DEE8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF5F6B7A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF0F766E),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onOpen,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFD8DEE8)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${task.priority} priority - Due ${formatDate(task.dueDate)}'),
        onTap: onOpen,
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No tasks in this filter.'),
    );
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
