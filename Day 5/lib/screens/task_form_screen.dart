import 'package:flutter/material.dart';

import '../models/task_item.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    this.existingTask,
  });

  final TaskItem? existingTask;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late String selectedPriority;
  late DateTime selectedDueDate;

  bool get isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;

    titleController = TextEditingController(text: task?.title ?? '');
    descriptionController = TextEditingController(text: task?.description ?? '');
    selectedPriority = task?.priority ?? 'Medium';
    selectedDueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) return;

    setState(() {
      selectedDueDate = pickedDate;
    });
  }

  void saveTask() {
    if (!formKey.currentState!.validate()) return;

    final existingTask = widget.existingTask;
    final task = TaskItem(
      id: existingTask?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      priority: selectedPriority,
      dueDate: selectedDueDate,
      isDone: existingTask?.isDone ?? false,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit task' : 'New task'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFD8DEE8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: 'Example: Build final project',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Title must have at least 3 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Write the task details',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 5) {
                              return 'Description must have at least 5 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: const InputDecoration(labelText: 'Priority'),
                          items: const [
                            DropdownMenuItem(value: 'Low', child: Text('Low')),
                            DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                            DropdownMenuItem(value: 'High', child: Text('High')),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedPriority = value;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: pickDueDate,
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text('Due date: ${formatDate(selectedDueDate)}'),
                        ),
                        const SizedBox(height: 22),
                        FilledButton.icon(
                          onPressed: saveTask,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(isEditing ? 'Save changes' : 'Create task'),
                        ),
                      ],
                    ),
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

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
