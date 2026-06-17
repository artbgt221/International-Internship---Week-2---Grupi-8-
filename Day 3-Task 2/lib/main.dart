import 'package:flutter/material.dart';

void main() {
  runApp(const TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day 3 Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const TrackerScreen(),
    );
  }
}

class TrackerItem {
  TrackerItem({
    required this.title,
    required this.category,
    required this.amount,
    this.isDone = false,
  });

  final String title;
  final String category;
  final double amount;
  bool isDone;
}

enum TrackerFilter { all, active, done }

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final List<TrackerItem> items = [
    TrackerItem(title: 'Prepare internship notes', category: 'Task', amount: 0),
    TrackerItem(title: 'Buy mobile data package', category: 'Expense', amount: 12.50),
    TrackerItem(title: 'Submit daily progress', category: 'Task', amount: 0, isDone: true),
  ];

  TrackerFilter selectedFilter = TrackerFilter.all;

  List<TrackerItem> get filteredItems {
    switch (selectedFilter) {
      case TrackerFilter.active:
        return items.where((item) => !item.isDone).toList();
      case TrackerFilter.done:
        return items.where((item) => item.isDone).toList();
      case TrackerFilter.all:
        return items;
    }
  }

  int get doneCount => items.where((item) => item.isDone).length;

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.amount);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> openAddItemDialog() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Task';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add new item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Example: Finish homework',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(value: 'Task', child: Text('Task')),
                        DropdownMenuItem(value: 'Expense', child: Text('Expense')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: '0 for tasks, e.g. 8.50 for expenses',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final String title = titleController.text.trim();
                    final double amount = double.tryParse(amountController.text.trim()) ?? 0;

                    if (title.isEmpty) {
                      showMessage('Please write a title first.');
                      return;
                    }

                    setState(() {
                      items.add(
                        TrackerItem(
                          title: title,
                          category: selectedCategory,
                          amount: amount,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                    showMessage('Item added successfully.');
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    amountController.dispose();
  }

  void toggleItemStatus(TrackerItem item) {
    setState(() {
      item.isDone = !item.isDone;
    });

    showMessage(item.isDone ? 'Item marked as done.' : 'Item marked as active.');
  }

  void deleteItem(TrackerItem item) {
    setState(() {
      items.remove(item);
    });

    showMessage('Item deleted.');
  }

  @override
  Widget build(BuildContext context) {
    final List<TrackerItem> visibleItems = filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task / Expense Tracker'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddItemDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SummaryCard(label: 'Total items', value: '${items.length}'),
                      SummaryCard(label: 'Done', value: '$doneCount'),
                      SummaryCard(label: 'Active', value: '${items.length - doneCount}'),
                      SummaryCard(label: 'Expenses', value: '\$${totalAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<TrackerFilter>(
                    segments: const [
                      ButtonSegment(value: TrackerFilter.all, label: Text('All')),
                      ButtonSegment(value: TrackerFilter.active, label: Text('Active')),
                      ButtonSegment(value: TrackerFilter.done, label: Text('Done')),
                    ],
                    selected: {selectedFilter},
                    onSelectionChanged: (selection) {
                      setState(() {
                        selectedFilter = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: visibleItems.isEmpty
                        ? const EmptyState()
                        : ListView.separated(
                            itemCount: visibleItems.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final TrackerItem item = visibleItems[index];

                              return TrackerItemTile(
                                item: item,
                                onToggle: () => toggleItemStatus(item),
                                onDelete: () => deleteItem(item),
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

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF5F6B7A),
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

class TrackerItemTile extends StatelessWidget {
  const TrackerItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final TrackerItem item;
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Checkbox(
          value: item.isDone,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            decoration: item.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          item.amount > 0
              ? '${item.category} - \$${item.amount.toStringAsFixed(2)}'
              : item.category,
        ),
        trailing: IconButton(
          tooltip: 'Delete',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No items in this filter.',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF5F6B7A),
            ),
      ),
    );
  }
}
