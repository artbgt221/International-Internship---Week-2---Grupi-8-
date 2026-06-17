import 'package:flutter/material.dart';

import 'expense_item.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    required this.item,
    super.key,
  });

  final ExpenseItem item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Details')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text('Category: ${item.category}'),
                      const SizedBox(height: 8),
                      Text('Amount: \$${item.amount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(item.isPaid ? 'Paid' : 'Unpaid'),
                        avatar: Icon(item.isPaid ? Icons.check_circle : Icons.pending_actions),
                        backgroundColor: item.isPaid ? colors.primaryContainer : colors.tertiaryContainer,
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
