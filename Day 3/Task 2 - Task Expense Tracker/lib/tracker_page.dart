import 'package:flutter/material.dart';

import 'add_expense_dialog.dart';
import 'detail_page.dart';
import 'expense_item.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final List<ExpenseItem> _items = <ExpenseItem>[
    const ExpenseItem(
      id: '1',
      title: 'Course materials',
      category: 'Study',
      amount: 42.5,
      isPaid: true,
    ),
    const ExpenseItem(
      id: '2',
      title: 'Transit pass',
      category: 'Travel',
      amount: 28,
      isPaid: false,
    ),
  ];

  double get _totalAmount => _items.fold<double>(0, (double total, ExpenseItem item) => total + item.amount);
  int get _paidCount => _items.where((ExpenseItem item) => item.isPaid).length;
  int get _unpaidCount => _items.length - _paidCount;

  Future<void> _openAddDialog() async {
    final ExpenseItem? item = await showDialog<ExpenseItem>(
      context: context,
      builder: (_) => const AddExpenseDialog(),
    );

    if (item == null) {
      return;
    }

    setState(() {
      _items.insert(0, item);
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} added')),
    );
  }

  void _togglePaid(ExpenseItem item) {
    final int index = _items.indexWhere((ExpenseItem current) => current.id == item.id);
    if (index == -1) {
      return;
    }

    setState(() {
      _items[index] = item.copyWith(isPaid: !item.isPaid);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} marked ${item.isPaid ? 'unpaid' : 'paid'}')),
    );
  }

  void _deleteItem(ExpenseItem item) {
    setState(() {
      _items.removeWhere((ExpenseItem current) => current.id == item.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} deleted')),
    );
  }

  void _openDetails(ExpenseItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _SummaryPanel(
                    totalAmount: _totalAmount,
                    paidCount: _paidCount,
                    unpaidCount: _unpaidCount,
                    itemCount: _items.length,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(child: Text('No expenses yet'))
                        : ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final ExpenseItem item = _items[index];

                              return Card(
                                child: ListTile(
                                  key: Key('expenseTile${item.id}'),
                                  onTap: () => _openDetails(item),
                                  leading: Checkbox(
                                    key: Key('paidToggle${item.id}'),
                                    value: item.isPaid,
                                    onChanged: (_) => _togglePaid(item),
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text('${item.category} • \$${item.amount.toStringAsFixed(2)}'),
                                  trailing: IconButton(
                                    key: Key('delete${item.id}'),
                                    tooltip: 'Delete',
                                    onPressed: () => _deleteItem(item),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ),
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

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.totalAmount,
    required this.paidCount,
    required this.unpaidCount,
    required this.itemCount,
  });

  final double totalAmount;
  final int paidCount;
  final int unpaidCount;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          children: <Widget>[
            _SummaryChip(label: 'Total', value: '\$${totalAmount.toStringAsFixed(2)}'),
            _SummaryChip(label: 'Items', value: '$itemCount'),
            _SummaryChip(label: 'Paid', value: '$paidCount'),
            _SummaryChip(label: 'Unpaid', value: '$unpaidCount'),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
