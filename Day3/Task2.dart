import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleTrackerApp());
}

class TrackerItem {
  final String title;
  bool done;

  TrackerItem({
    required this.title,
    this.done = false,
  });
}

class SimpleTrackerApp extends StatefulWidget {
  const SimpleTrackerApp({super.key});

  @override
  State<SimpleTrackerApp> createState() => _SimpleTrackerAppState();
}

class _SimpleTrackerAppState extends State<SimpleTrackerApp> {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController itemController = TextEditingController();

  final List<TrackerItem> items = [
    TrackerItem(title: 'Finish Flutter task'),
    TrackerItem(title: 'Upload screenshot'),
  ];

  String errorMessage = '';

  int get doneCount {
    return items.where((item) => item.done).length;
  }

  int get activeCount {
    return items.where((item) => !item.done).length;
  }

  void showMessage(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void addItem() {
    String title = itemController.text.trim();

    if (title.isEmpty) {
      setState(() {
        errorMessage = 'Please enter an item.';
      });
      return;
    }

    setState(() {
      items.add(
        TrackerItem(title: title),
      );

      itemController.clear();
      errorMessage = '';
    });

    showMessage('Item added!');
  }

  void toggleStatus(int index) {
    setState(() {
      items[index].done = !items[index].done;
    });

    if (items[index].done) {
      showMessage('Item marked as done!');
    } else {
      showMessage('Item marked as active!');
    }
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });

    showMessage('Item deleted!');
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Task Tracker',
      home: Scaffold(
        backgroundColor: const Color(0xFFECEFF1),
        appBar: AppBar(
          title: const Text('Task Tracker'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.checklist,
                                size: 70,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Add New Item',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: itemController,
                                decoration: const InputDecoration(
                                  labelText: 'Item title',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.edit),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                  onPressed: addItem,
                                  child: const Text('Add Item'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              const Text(
                                'Summary',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Total items: ${items.length}'),
                              Text('Done: $doneCount'),
                              Text('Active: $activeCount'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Item List',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: item.done,
                                onChanged: (value) {
                                  toggleStatus(index);
                                },
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: item.done
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                item.done
                                    ? 'Status: Done'
                                    : 'Status: Active',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteItem(index);
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
