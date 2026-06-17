import 'package:flutter/material.dart';

void main() {
  runApp(const TrackerApp());
}

class TrackerItem {
  final String title;
  final double amount;
  bool paid;

  TrackerItem({
    required this.title,
    required this.amount,
    this.paid = false,
  });
}

class TrackerApp extends StatefulWidget {
  const TrackerApp({super.key});

  @override
  State<TrackerApp> createState() => _TrackerAppState();
}

class _TrackerAppState extends State<TrackerApp> {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<TrackerItem> items = [
    TrackerItem(title: 'Lunch', amount: 5.50, paid: true),
    TrackerItem(title: 'Transport', amount: 2.00, paid: false),
    TrackerItem(title: 'Notebook', amount: 3.20, paid: false),
  ];

  String errorMessage = '';

  double get totalAmount {
    double total = 0;
    for (var item in items) {
      total += item.amount;
    }
    return total;
  }

  int get paidCount {
    return items.where((item) => item.paid).length;
  }

  int get unpaidCount {
    return items.where((item) => !item.paid).length;
  }

  void showMessage(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void addItem() {
    String title = titleController.text.trim();
    String amountText = amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields.';
      });
      return;
    }

    double? amount = double.tryParse(amountText);

    if (amount == null) {
      setState(() {
        errorMessage = 'Please enter a valid number.';
      });
      return;
    }

    setState(() {
      items.add(
        TrackerItem(
          title: title,
          amount: amount,
        ),
      );

      titleController.clear();
      amountController.clear();
      errorMessage = '';
    });

    showMessage('Item added successfully!');
  }

  void togglePaid(int index) {
    setState(() {
      items[index].paid = !items[index].paid;
    });

    if (items[index].paid) {
      showMessage('Item marked as paid!');
    } else {
      showMessage('Item marked as unpaid!');
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
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'Expense Tracker',
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
          title: const Text('Expense Tracker'),
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
                                Icons.account_balance_wallet,
                                size: 75,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Add Expense Item',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Item title',
                                  prefixIcon: Icon(Icons.title),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Amount',
                                  prefixIcon: Icon(Icons.euro),
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
                        elevation: 5,
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
                              const SizedBox(height: 12),
                              Text(
                                'Total items: ${items.length}',
                                style: const TextStyle(fontSize: 17),
                              ),
                              Text(
                                'Paid: $paidCount',
                                style: const TextStyle(fontSize: 17),
                              ),
                              Text(
                                'Unpaid: $unpaidCount',
                                style: const TextStyle(fontSize: 17),
                              ),
                              Text(
                                'Total amount: €${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Expense List',
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
                                value: item.paid,
                                onChanged: (value) {
                                  togglePaid(index);
                                },
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: item.paid
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                item.paid ? 'Status: Paid' : 'Status: Unpaid',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '€${item.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteItem(index);
                                    },
                                  ),
                                ],
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
