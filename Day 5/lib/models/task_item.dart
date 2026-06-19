class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isDone = false,
  });

  final int id;
  String title;
  String description;
  String priority;
  DateTime dueDate;
  bool isDone;
}
